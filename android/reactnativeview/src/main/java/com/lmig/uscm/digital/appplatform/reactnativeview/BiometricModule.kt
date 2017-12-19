package com.lmig.uscm.digital.appplatform.reactnativeview

/**
 * Created on 22/08/2017.
 */
import com.facebook.react.bridge.*
import com.lmig.uscm.digital.appplatform.appmanager.biometric.BiometricAuthenticationDialogFragment
import com.lmig.uscm.digital.appplatform.appmanager.biometric.BiometricUtils

class BiometricModule(internal var reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), BiometricAuthenticationDialogFragment.BiometricCallback {

    private var biometricPromise: Promise? = null

    /**
     * Retrieves credentials currently stored on the device
     * This is done using fingerprint authentication
     *
     * @return [String] The name of the React Native module
     */
    override fun getName(): String {
        return "Biometric"
    }

    /**
     * Retrieves credentials currently stored on the device
     * This is done using fingerprint authentication
     *
     * @param username the username to be saved
     * @param password the password to be saved
     * @param promise The callback to the React Native code
     */
    @ReactMethod
    fun saveCredentials(username: String, password: String, promise: Promise) {
        val fragment = BiometricAuthenticationDialogFragment()
        fragment.callback = this
        fragment.setAction(action = BiometricAuthenticationDialogFragment.Action.SAVE_CREDENTIALS)
        fragment.setCredentials(username = username, password = password)
        val activity = this.reactContext.currentActivity
        activity?.let {
            val manager = it.fragmentManager
            fragment.show(manager, DIALOG_FRAGMENT_TAG)
            this.biometricPromise = promise
        }
    }

    /**
     * Retrieves credentials currently stored on the device
     * This is done using fingerprint authentication
     *
     * @param promise The callback to the React Native code
     */
    @ReactMethod
    fun getCredentials(promise: Promise) {
        val fragment = BiometricAuthenticationDialogFragment()
        fragment.callback = this
        fragment.setAction(action = BiometricAuthenticationDialogFragment.Action.GET_CREDENTIALS)
        val activity = this.reactContext.currentActivity
        activity?.let {
            val manager = it.fragmentManager
            fragment.show(manager, DIALOG_FRAGMENT_TAG)
            this.biometricPromise = promise
        }
    }

    /**
     * Deletes credentials currently stored on the device
     *
     * @param promise The callback to the React Native code
     */
    @ReactMethod
    fun deleteCredentials(promise: Promise) {
        val success = BiometricUtils.deleteCredentials(context = reactContext)
        if(success) {
            promise.resolve(null)
        }
        else {
            promise.reject("ERROR", "Unable to delete credentials")
        }
    }

    /**
     * Checks whether biometric authentication is supported on the device
     *
     * @param promise The callback to the React Native code
     */
    @ReactMethod
    fun isSupported(promise: Promise) {
        promise.resolve(BiometricUtils.isSupported(context = reactContext))
    }

    /**
     * Get the type of biometric authentication available on this device
     * IMPORTANT: This always returns "fingerprint" as Android does not yet support facial recognition.
     * It also assumes you have already called "isSupported" to verify that Biometric Authentication of any type is supported.
     * Calling this function on its own will always return "fingerprint" even if no fingerprint recognition hardware is present on the device
     *
     * @param promise The callback to the React Native code
     */
    @ReactMethod
    fun getBiometricType(promise: Promise) {
        promise.resolve(BiometricUtils.getBiometricType())
    }

    /**
     * Checks whether credentials are stored on the device
     *
     * @param promise The callback to the React Native code
     */
    @ReactMethod
    fun hasCredentials(promise: Promise) {
        promise.resolve(BiometricUtils.hasCredentials(context = reactContext))
    }

    /**
     * Callback handler when retrieving crendentials succeeds
     *
     * @param username The retrieved username
     * @param password The retrieved password
     */
    override fun getCredentialsSuccess(username: String, password: String) {
        val response = Arguments.createMap()
        response.putString("username", username)
        response.putString("password", password)
        this.biometricPromise?.let {
            it.resolve(response)
        }

        // TODO: Add failure handler here (reject promise)
    }

    /**
     * Callback handler when retrieving crendentials fails
     *
     * @param reason Failure reason description
     */
    override fun getCredentialsFailure(reason: String) {
        this.biometricPromise?.let {
            it.reject("ERROR", reason)
        }
    }

    /**
     * Callback handler when saving crendentials succeeds
     *
     * @param success Boolean indicating saving success/failure
     */
    override fun saveCredentialsSuccess(success: Boolean) {
        this.biometricPromise?.let {
            if(success) {
                it.resolve(null)
            }
            else {
                it.reject("ERROR", "Unable to save credentials")
            }
        }
    }

    /**
     * Callback handler when saving crendentials fails
     *
     * @param reason Failure reason description
     */
    override fun saveCredentialsFailure(reason: String) {
        this.biometricPromise?.let {
            it.reject("ERROR", reason)
        }
    }

    /**
     * Callback handler when user cancels biometric authentication
     */
    override fun authenticateCancelled() {
        this.biometricPromise?.let {
            it.reject("ERROR", "User cancelled")
        }
    }

    companion object {

        private val DIALOG_FRAGMENT_TAG = "BiometricAuthenticationDialogFragment"
    }
}
