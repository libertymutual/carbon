package com.lmig.uscm.digital.appplatform.appmanager.biometric

/**
 * Created on 23/08/2017.
 */

import android.app.DialogFragment
import android.os.Bundle
import android.support.v4.hardware.fingerprint.FingerprintManagerCompat
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import com.lmig.uscm.digital.appplatform.appmanager.R

/**
 * A dialog which uses fingerprint APIs to authenticate the user
 */
class BiometricAuthenticationDialogFragment : DialogFragment(), BiometricUiHelper.Callback {

    // Biometric Encryption class which handles all encryption / decryption logic
    private var biometricEncryption: BiometricEncryption? = null

    // Cancel button
    private var mCancelButton: Button? = null

    // UI Helper class for displaying / managing fingerprint UI
    private var mFingerprintUiHelper: BiometricUiHelper? = null

    // Reference to the callback where we send the success / failure results of the authentication
    var callback: BiometricCallback? = null

    // The action to be performed (GET_CREDENTIALS / SAVE_CREDENTIALS)
    private var mAction = Action.GET_CREDENTIALS

    // The username to be saved
    private var usernameToSave = ""

    // The password to be saved
    private var passwordToSave = ""

    /**
     * Overridden [DialogFragment] function. Overridden here to perform initial fragment setup
     *
     * Perform initial Fragment setup & instantiate the [BiometricEncryption] instance.
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Do not create a new Fragment when the Activity is re-created such as orientation changes.
        retainInstance = true
        setStyle(DialogFragment.STYLE_NORMAL, android.R.style.Theme_Material_Light_Dialog)

        // Init the Biometric Encryption Class
        biometricEncryption = BiometricEncryption(context = activity,action = mAction)
    }

    /**
     * Overridden [DialogFragment] function. Overridden here to perform initial fragment setup
     *
     * Set dialog title, inflate view, configure cancel button
     *
     * @return The main [View] for the [DialogFragment]
     */
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        dialog.setTitle(getString(R.string.sign_in))
        val view = inflater.inflate(R.layout.fingerprint_dialog_container, container, false)
        mCancelButton = view.findViewById(R.id.cancel_button)
        mCancelButton?.setText(R.string.cancel)
        mCancelButton?.setOnClickListener {
            callback?.authenticateCancelled()
            dismiss()
        }

        mFingerprintUiHelper = BiometricUiHelper(context = activity,
                fingerprintManager = FingerprintManagerCompat.from(activity),
                icon = view.findViewById(R.id.fingerprint_icon),
                textView = view.findViewById(R.id.fingerprint_status), callback = this)
        return view
    }

    /**
     * Overridden [DialogFragment] function. Overridden here to start uiHelper listening for fingerprints
     */
    override fun onResume() {
        super.onResume()
        mFingerprintUiHelper?.let { uiHelper ->
            biometricEncryption?.let { biometricEncrypt ->
                uiHelper.startListening(cryptoObject = biometricEncrypt.cryptoObject)
            }
        }
    }

    /**
     * Overridden [DialogFragment] function. Overridden here to stop uiHelper
     * from listening for fingerprints
     */
    override fun onPause() {
        super.onPause()
        mFingerprintUiHelper?.let { uiHelper ->
            uiHelper.stopListening()
        }
    }

    /**
     * Sets the action to be performed (GET_CREDENTIALS / SAVE_CREDENTIALS)
     *
     * @param action The action to be performed
     */
    fun setAction(action: Action) {
        mAction = action
    }


    /**
     * Sets the username & password credentials to be encrypted
     *
     * @param username The username to be encrypted
     * @param password The password to be encrypted
     */
    fun setCredentials(username: String, password: String) {
        usernameToSave = username
        passwordToSave = password
    }

    /**
     * Implementation of [BiometricUiHelper.Callback] function for handling biometric success scenarios
     */
    override fun onAuthenticated() {
        if (mAction == Action.GET_CREDENTIALS) {
            biometricEncryption?.let {
                val results = it.tryDecrypt()
                val username = results["username"]
                val password = results["password"]
                username?.let { uName ->
                    password?.let { pWord ->
                        callback?.getCredentialsSuccess(username = uName, password = pWord)
                    }
                }
            } ?: run {
                callback?.getCredentialsFailure(reason = "Unable to retrieve credentials")
            }
        }
        else if (mAction == Action.SAVE_CREDENTIALS) {
            biometricEncryption?.let {
                it.tryEncrypt(usernameToSave, passwordToSave)
                callback?.saveCredentialsSuccess(success = true)
            } ?: run {
                callback?.saveCredentialsFailure(reason = "Unable to save credentials")
            }
        }
        dismissAllowingStateLoss()
    }

    /**
     * Implementation of [BiometricUiHelper.Callback] function for handling biometric error scenarios
     */
    override fun onError() {
        if (mAction == Action.GET_CREDENTIALS) {
            callback?.getCredentialsFailure(reason = "Unable to retrieve credentials")
        }
        else if (mAction == Action.SAVE_CREDENTIALS) {
            callback?.saveCredentialsFailure(reason = "Unable to save credentials")
        }
        dismissAllowingStateLoss()
    }

    /**
     * Interface for handling Biometric Callbacks
     */
    interface BiometricCallback {

        /**
         * Callback handler when retrieving credentials succeeds
         *
         * @param username The retrieved username
         * @param password The retrieved password
         */
        fun getCredentialsSuccess(username: String, password: String)

        /**
         * Callback handler when retrieving credentials fails
         *
         * @param reason Failure reason description
         */
        fun getCredentialsFailure(reason: String)

        /**
         * Callback handler when saving credentials succeeds
         *
         * @param success Boolean indicating saving success/failure
         */
        fun saveCredentialsSuccess(success: Boolean)

        /**
         * Callback handler when saving credentials fails
         *
         * @param reason Failure reason description
         */
        fun saveCredentialsFailure(reason: String)

        /**
         * Callback handler when user cancels biometric authentication
         */
        fun authenticateCancelled()
    }

    /**
     * Enumeration to indicate which type of authentication action the user is trying to perform
     */
    enum class Action {
        GET_CREDENTIALS,
        SAVE_CREDENTIALS
    }
}
