package com.lmig.uscm.digital.appplatform.appmanager.biometric

import android.content.Context
import android.support.v4.content.ContextCompat
import android.support.v4.hardware.fingerprint.FingerprintManagerCompat
import android.support.v4.os.CancellationSignal
import android.widget.ImageView
import android.widget.TextView
import com.lmig.uscm.digital.appplatform.appmanager.R

/**
 * Small helper class to manage text/icon around biometric authentication UI.
 */
class BiometricUiHelper
/**
 * Constructor for [BiometricUiHelper]
 * 
 * @property context A [Context] object
 * @property fingerprintManager A reference to the fingerprint manager for checking biometric support
 * @property icon The image to display in the fingerprint dialog
 * @property textView The text view for displaying text feedback
 * @property callback The callback for sending handling success/error results
 */
internal constructor(private val context: Context, private val fingerprintManager: FingerprintManagerCompat,
                     private val icon: ImageView, private val textView: TextView, private val callback: Callback) : FingerprintManagerCompat.AuthenticationCallback() {

    // Cancellation signal which listens for cancel events on the FingerPrint Manager
    private var mCancellationSignal: CancellationSignal? = null

    // Boolean tracking if the fingerprint listener was self cancelled
    private var mSelfCancelled: Boolean = false

    // Indicates if fingerprint auth is available
    private val isFingerprintAuthAvailable: Boolean
        /**
         * Determines if fingerprint auth is available
         *
         * @return [Boolean] indicating if fingerprint auth is available
         */
        get() = fingerprintManager.isHardwareDetected && fingerprintManager.hasEnrolledFingerprints()

    /**
     * Start listening for fingerprints
     *
     * @param cryptoObject The [CryptoObject] to be unlocked by Fingerprint auth (and used for encryption / decryption)
     */
    fun startListening(cryptoObject: FingerprintManagerCompat.CryptoObject?) {
        if (!isFingerprintAuthAvailable) {
            return
        }
        mCancellationSignal = CancellationSignal()
        mSelfCancelled = false
        // The line below prevents the false positive inspection from Android Studio

        //noinspection MissingPermission
        fingerprintManager.authenticate(cryptoObject, 0 /* flags */, mCancellationSignal, this, null)
        icon.setImageResource(R.drawable.ic_fp_40px)
    }

    /**
     * Stop listening for fingerprints
     */
    fun stopListening() {
        mCancellationSignal?.let {
            mSelfCancelled = true
            it.cancel()
            mCancellationSignal = null
        }
    }

    /**
     * Implementation of [FingerprintManagerCompat.AuthenticationCallback] function for handling Fingerprint manager authentication errors
     */
    override fun onAuthenticationError(errMsgId: Int, errString: CharSequence) {
        if (!mSelfCancelled) {
            showError(error = errString)
            icon.postDelayed({ callback.onError() }, ERROR_TIMEOUT_MILLIS)
        }
    }

    /**
     * Implementation of [FingerprintManagerCompat.AuthenticationCallback] function for handling Fingerprint manager help requests
     */
    override fun onAuthenticationHelp(helpMsgId: Int, helpString: CharSequence) {
        showError(error = helpString)
    }

    /**
     * Implementation of [FingerprintManagerCompat.AuthenticationCallback] function for handling Fingerprint manager authentication failures
     */
    override fun onAuthenticationFailed() {
        showError(error = icon.resources.getString(
                R.string.fingerprint_not_recognized))
    }

    /**
     * Implementation of [FingerprintManagerCompat.AuthenticationCallback] function for handling Fingerprint manager authentication success
     */
    override fun onAuthenticationSucceeded(result: FingerprintManagerCompat.AuthenticationResult) {
        textView.removeCallbacks(mResetErrorTextRunnable)
        icon.setImageResource(R.drawable.ic_fingerprint_success)
        textView.setTextColor(
                ContextCompat.getColor(context, R.color.success_color))
        textView.text = textView.resources.getString(R.string.fingerprint_success)
        icon.postDelayed({ callback.onAuthenticated() }, SUCCESS_DELAY_MILLIS)
    }

    /**
     * Display error message to the user on the [DialogFragment]
     *
     * @param error The error message to display
     */
    private fun showError(error: CharSequence) {
        icon.setImageResource(R.drawable.ic_fingerprint_error)
        textView.text = error
        textView.setTextColor(
                ContextCompat.getColor(context, R.color.warning_color))
        textView.removeCallbacks(mResetErrorTextRunnable)
        textView.postDelayed(mResetErrorTextRunnable, ERROR_TIMEOUT_MILLIS)
    }

    /**
     * Runnable for resetting error text
     */
    private val mResetErrorTextRunnable = Runnable {
        textView.setTextColor(
                ContextCompat.getColor(context, R.color.hint_color))
        textView.text = textView.resources.getString(R.string.fingerprint_hint)
        icon.setImageResource(R.drawable.ic_fp_40px)
    }

    /**
     * Interface for handling Biometric UI Helper Callbacks
     */
    interface Callback {

        /**
         * Callback function for authentication success
         */
        fun onAuthenticated()

        /**
         * Callback function for authentication error / failure
         */
        fun onError()
    }

    companion object {

        // Error Message Display Timeout (Before performing next actions)
        private val ERROR_TIMEOUT_MILLIS: Long = 1600

        // Success Message Display Timeout (Before performing next actions)
        private val SUCCESS_DELAY_MILLIS: Long = 1300
    }
}
