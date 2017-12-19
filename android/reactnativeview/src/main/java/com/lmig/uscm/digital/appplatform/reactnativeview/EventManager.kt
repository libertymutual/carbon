package com.lmig.uscm.digital.appplatform.reactnativeview

import com.facebook.react.bridge.*
import com.lmig.uscm.digital.appplatform.appmanager.CommonEventManager

/**
 * Event Manager
 *
 * React Native specific implementation of Event Manager
 *
 * @param [reactContext] The [ReactApplicationContext] for the React Native module
 * @param [eventMan] The [CommonEventManager] for the React Native module
 */
class EventManager(reactContext: ReactApplicationContext?, val eventMan: CommonEventManager) : ReactContextBaseJavaModule(reactContext) {

    /**
     * Overridden implementation of the [ReactContextBaseJavaModule.getName] function
     *
     * @return The name of the current [ReactContextBaseJavaModule] - EventManager
     */
    override fun getName(): String {
        return "EventManager"
    }

    /**
     * Return a [String] indicating the current Build Type (e.g. debug, qa, release)
     *
     * @param [featureName] The name of the feature to navigate to
     * @param [options] A map of navigation options
     */
    @ReactMethod
    fun navigateFromReactNative(featureName: String, options: ReadableMap) {
        // Default to an empty HashMap for instances where options is not a ReadableNativeMap
        var navOptions = HashMap<String, Any>()

        if(options is ReadableNativeMap) {
            navOptions = options.toHashMap()
        }

        // Call navigateFromReactNative on the CommonEventManager
        eventMan.navigateFromReactNative(featureName = featureName, options = navOptions)
    }

    /**
     * Navigates the user from the React Native View to any other module
     *
     * @param promise The callback to the React Native code
     */
    @ReactMethod
    fun getBuildType(promise: Promise) {
        eventMan.app.appConfig?.buildType?.let {
            promise.resolve(it)
        }
    }

}