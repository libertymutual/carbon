package com.lmig.uscm.digital.appplatform.appmanager.biometric

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.preference.PreferenceManager
import android.support.v4.app.ActivityCompat
import android.support.v4.hardware.fingerprint.FingerprintManagerCompat
import java.security.KeyStore

/**
 * Utils class containing Biometric authentication related helper functions
 */
class BiometricUtils {
    companion object {

        // Android Keystore Key Name
        private val KEY_NAME = "biometric_module_key"

        /**
         * Deletes credentials currently stored on the device
         *
         * @param context A Context used for getting a handle on SharedPreferences
         *
         * @return [Boolean] A Boolean indicating whether the deletion was successful
         */
        fun deleteCredentials(context: Context): Boolean {
            // Delete the Key from the KeyStore
            val keyStore = KeyStore.getInstance("AndroidKeyStore")
            keyStore.load(null)
            keyStore.deleteEntry(KEY_NAME)

            // Delete the Credentials from SharedPreferences
            val mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)
            val editor = mSharedPreferences.edit()
            editor.remove("credentials")
            editor.remove("iv")
            return editor.commit()
        }

        /**
         * Checks whether biometric authentication is supported on the device
         *
         * @param context A Context used for getting a handle on SharedPreferences
         *
         * @return [Boolean] A Boolean indicating whether biometric authentication is supported on the device
         */
        fun isSupported(context: Context): Boolean {
            val fingerprintManager = FingerprintManagerCompat.from(context)
            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.USE_FINGERPRINT) != PackageManager.PERMISSION_GRANTED) {
                return false
            }

            if (!fingerprintManager.isHardwareDetected) {
                return false
            }

            if (!fingerprintManager.hasEnrolledFingerprints()) {
                return false
            }
            return true
        }

        /**
         * Get the type of biometric authentication available on this device
         * IMPORTANT: This always returns "fingerprint" as Android does not yet support facial recognition.
         * It also assumes you have already called "isSupported" to verify that Biometric Authentication of any type is supported.
         * Calling this function on its own will always return "fingerprint" even if no fingerprint recognition hardware is present on the device
         *
         * @return [String] A value describing the type of biometric authentication available
         */
        fun getBiometricType(): String {
            return "fingerprint"
        }

        /**
         * Checks whether credentials are stored on the device
         *
         * @param context A Context used for getting a handle on SharedPreferences
         *
         * @return [Boolean] A Boolean indicating whether credentials are stored on the device
         */
        fun hasCredentials(context: Context): Boolean {
            val mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)
            return mSharedPreferences.contains("credentials")
        }
    }
}