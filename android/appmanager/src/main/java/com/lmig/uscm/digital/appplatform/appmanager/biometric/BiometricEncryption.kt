package com.lmig.uscm.digital.appplatform.appmanager.biometric

import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.preference.PreferenceManager
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.support.v4.hardware.fingerprint.FingerprintManagerCompat
import android.util.Base64
import java.security.*
import javax.crypto.*
import javax.crypto.spec.IvParameterSpec

/**
 * Biometric Encryption class for handling all encryption / decryption logic for Biometric Authentication
 */
class BiometricEncryption(val context: Context, private val action: BiometricAuthenticationDialogFragment.Action) {

    // Shared Preferences reference for saving / retrieving biometric related credentials
    private var mSharedPreferences: SharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)

    // The Crypto Object used for encrypting / decrypting credentials
    var cryptoObject: FingerprintManagerCompat.CryptoObject

    // Android Keystore Key Name
    private val KEY_NAME = "biometric_module_key"

    /**
     * Init the Biometric Encryption instance
     *
     * Configures the [Key], [Cipher] & [CryptoObject]
     */
    init {
        val key = configureKey()
        val cipher = configureCipher(key = key)
        cryptoObject = FingerprintManagerCompat.CryptoObject(cipher)
    }

    /**
     * Gets the Key used for encryption / decryption
     * Key is created if it doesn't exist
     * (because we are in SAVE_CREDENTIALS mode)
     *
     * @return [Key] the key used to init the cipher
     */
    private fun configureKey(): Key {
        val keyStore = KeyStore.getInstance("AndroidKeyStore")
        keyStore.load(null)

        // If we are in SAVE_CREDENTIALS mode, then we need to create a new key in the KeyStore
        if(action === BiometricAuthenticationDialogFragment.Action.SAVE_CREDENTIALS){
            createKey()
        }

        return keyStore.getKey(KEY_NAME, null) as SecretKey
    }

    /**
     * Creates a symmetric key in the Android Key Store which can only be used after the user has
     * authenticated with fingerprint.
     *
     * @param key the key used to init the cipher
     */
    private fun configureCipher(key: Key): Cipher {

        // Create the Cipher
        val cipher = Cipher.getInstance(KeyProperties.KEY_ALGORITHM_AES + "/"
                + KeyProperties.BLOCK_MODE_CBC + "/"
                + KeyProperties.ENCRYPTION_PADDING_PKCS7)

        // If we are GET_CREDENTIALS mode, then init the Cipher with the saved IV
        if(action == BiometricAuthenticationDialogFragment.Action.GET_CREDENTIALS){
            // Retrieve the initialisation vector (IV) from SharedPreferences
            val iv = mSharedPreferences.getString("iv", "")
            val cipherIv = Base64.decode(iv, Base64.DEFAULT)
            val ivParams = IvParameterSpec(cipherIv)

            // Init the cipher
            cipher.init(Cipher.DECRYPT_MODE, key, ivParams)
        }
        // If we are in SAVE_CREDENTIALS mode, init the Cipher, then save the IV
        else {
            // Init the cipher
            cipher.init(Cipher.ENCRYPT_MODE, key)

            // Save the initialisation vector (IV) to SharedPreferences for later use
            val iv = cipher.iv
            val encodeCipherIv = Base64.encodeToString(iv, Base64.DEFAULT)
            val editor = mSharedPreferences.edit()
            editor.putString("iv", encodeCipherIv)
            editor.commit()
        }

        return cipher
    }

    /**
     * Creates a symmetric key in the Android Key Store which can only be used after the user has
     * authenticated with fingerprint.
     */
    private fun createKey() {
        // Set the alias of the entry in Android KeyStore where the key will appear
        // and the constrains (purposes) in the constructor of the Builder
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val builder = KeyGenParameterSpec.Builder(KEY_NAME,
                    KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
                    .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
                    // Require the user to authenticate with a fingerprint to authorize every use
                    // of the key
                    .setUserAuthenticationRequired(true)
                    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)

            // Generate the Key
            val mKeyGenerator = KeyGenerator
                    .getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
            mKeyGenerator.init(builder.build())
            mKeyGenerator.generateKey()
        }
    }

    /**
     * Tries to encrypt some data with the generated key
     * only works if the user has just authenticated via fingerprint.
     *
     * @param username the username to be encrypted
     * @param password the password to be encrypted
     */
    fun tryEncrypt(username: String, password: String) {
        // Concat the username & password, delimited by *****
        val data = username + "*****"+ password

        // Encrypt the values using the cipher
        val encryptedData = cryptoObject.cipher.doFinal(data.toByteArray())

        // Convert to Base64
        val encryptedDataBase64 = Base64.encodeToString(encryptedData, Base64.DEFAULT)

        // Save to SharedPreferences
        val editor = mSharedPreferences.edit()
        editor.putString("credentials", encryptedDataBase64)
        editor.commit()
    }

    /**
     * Tries to decrypt some data with the generated key
     * only works if the user has just authenticated via fingerprint.
     *
     * @return [HashMap] A HashMap containing the decrypted username & password
     */
    fun tryDecrypt(): Map<String, String> {
        val response = HashMap<String, String>()

        // Retrieve the encrypted value from Shared Preferences
        val encryptedDataBase64 = mSharedPreferences.getString("credentials", "")

        // Conver the data from Base64
        val encryptedData = Base64.decode(encryptedDataBase64, Base64.DEFAULT)

        // Decrypt the value using the cipher
        val decryptedCredentialsBytes = cryptoObject.cipher.doFinal(encryptedData)

        // Convert to a string
        val decryptedCredentials = String(decryptedCredentialsBytes)

        // Split into parts based on the ***** delimiter
        val parts = decryptedCredentials.split("*****")
        val username = parts[0]
        val password = parts[1]

        // Add to the response
        response.put("username", username)
        response.put("password", password)

        return response
    }
}