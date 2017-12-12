package com.lmig.uscm.digital.appplatform.reactnativeview

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.support.v7.app.AppCompatActivity
import android.view.KeyEvent
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactPackage
import com.facebook.react.ReactRootView
import com.facebook.react.common.LifecycleState
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler
import com.facebook.react.shell.MainReactPackage
import com.lmig.uscm.digital.appplatform.appmanager.AppPlatformApplication

/**
 * React Native View
 *
 * A React Native Android [AppCompatActivity] which represents the core functionality of the React Native View Module
 *
 * @property [mReactRootView] The [ReactRootView] required by React Native
 * @property [mReactInstanceManager] The [ReactInstanceManager] required by React Native
 * @property [OVERLAY_PERMISSION_REQ_CODE] A static request code used when checking/requesting App Overlay Permissions
 */
class ReactNativeView : AppCompatActivity(), DefaultHardwareBackBtnHandler {
    private var mReactRootView: ReactRootView? = null
    private var mReactInstanceManager: ReactInstanceManager? = null

    private val OVERLAY_PERMISSION_REQ_CODE = 1235

    /**
     * Overridden implementation of the Android [AppCompatActivity.onCreate] function
     *
     * @param [savedInstanceState] The saved instance [Bundle]
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Check if we have the required permissions
        val appPermissionsValid = checkPermissions()

        // If permissions are ok, launch React Native, otherwise
        // request the required permissions
        if(appPermissionsValid) {
            launchReactNativeView()
        }
        else{
            requestAppPermissions()
        }
    }

    /**
     * Launches the React Native View
     */
    private fun launchReactNativeView () {
        val app = applicationContext as AppPlatformApplication
        app.eventManager?.let { eventMan ->
            val moduleName = intent.getStringExtra("moduleName")

            mReactRootView = ReactRootView(this)
            mReactInstanceManager = ReactInstanceManager.builder()
                    .setApplication(application)
                    .setBundleAssetName("index.android.bundle")
                    .setJSMainModulePath("index.android")
                    .addPackage(MainReactPackage())
                    .addPackage(ReactNativeBridge(eventMan = eventMan) as ReactPackage)
                    .setUseDeveloperSupport(!BuildConfig.USE_REACT_NATIVE_BUNDLE)
                    .setInitialLifecycleState(LifecycleState.RESUMED)
                    .build()
            mReactRootView!!.startReactApplication(mReactInstanceManager, moduleName, null)

            setContentView(mReactRootView)
        }
    }

    /**
     * Launches an Activity to request App Overlay Permissions
     */
    private fun requestAppPermissions() {
        val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:" + packageName))
        startActivityForResult(intent, OVERLAY_PERMISSION_REQ_CODE)
    }

    /**
     * Checks if the app has the required permissions to launch
     *
     * In this instance, if the user is running in debug mode, then they must also have
     * App Overlay Permissions in order to launch the React Native View
     *
     * @return A [Boolean] indicating if the app currently has App Overlay Permissions
     */
    private fun checkPermissions (): Boolean {
        var permissionsValid = true
        // If running against development server, check if we have the required permissions
        if(!BuildConfig.USE_REACT_NATIVE_BUNDLE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (!Settings.canDrawOverlays(this)) {
                    permissionsValid = false
                }
            }
        }
        return permissionsValid
    }

    /**
     * Overridden implementation of the Android [AppCompatActivity.onActivityResult] function
     *
     * Used to handle result of requesting App Overlay Permissions
     *
     * @param [requestCode] The request code of the Activity result being handled
     * @param [resultCode] The result code of the Activity result being handled
     * @param [data] The original [Intent]
     */
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == OVERLAY_PERMISSION_REQ_CODE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (Settings.canDrawOverlays(this)) {
                    launchReactNativeView()
                }
                else{
                    // TODO: SYSTEM_ALERT_WINDOW permission not granted...
                }
            }
        }
    }

    /**
     * Overridden implementation of the Android [AppCompatActivity.invokeDefaultOnBackPressed] function
     *
     * Currently to used to bubble up React Native onBackPressed events
     */
    override fun invokeDefaultOnBackPressed() {
        super.onBackPressed()
    }

    /**
     * Overridden implementation of the Android [AppCompatActivity.onPause] function
     *
     * Currently to used to bubble up React Native onPause events
     */
    override fun onPause() {
        super.onPause()

        if (mReactInstanceManager != null) {
            (mReactInstanceManager as ReactInstanceManager).onHostPause(this)
        }
    }

    /**
     * Overridden implementation of the Android [AppCompatActivity.onResume] function
     *
     * Currently to used to bubble up React Native onResume events
     */
    override fun onResume() {
        super.onResume()

        if (mReactInstanceManager != null) {
            (mReactInstanceManager as ReactInstanceManager).onHostResume(this, this)
        }
    }

    /**
     * Overridden implementation of the Android [AppCompatActivity.onDestroy] function
     *
     * Currently to used to bubble up React Native onDestroy events
     */
    override fun onDestroy() {
        super.onDestroy()

        if (mReactInstanceManager != null) {
            (mReactInstanceManager as ReactInstanceManager).onHostDestroy()
        }
    }

    /**
     * Overridden implementation of the Android [AppCompatActivity.onBackPressed] function
     *
     * Currently to used to bubble up React Native onBackPressed events
     */
    override fun onBackPressed() {
        if (mReactInstanceManager != null) {
            (mReactInstanceManager as ReactInstanceManager).onBackPressed()
        } else {
            super.onBackPressed()
        }
    }

    /**
     * Overridden implementation of the Android [AppCompatActivity.onKeyUp] function
     *
     * Currently to used to bubble up React Native onKeyUp events
     * Also used to add additional handling for React Native Dev Options Dialog
     */
    override fun onKeyUp(keyCode: Int, event: KeyEvent): Boolean {
        if (keyCode == KeyEvent.KEYCODE_MENU && mReactInstanceManager != null) {
            (mReactInstanceManager as ReactInstanceManager).showDevOptionsDialog()
            return true
        }
        return super.onKeyUp(keyCode, event)
    }
}