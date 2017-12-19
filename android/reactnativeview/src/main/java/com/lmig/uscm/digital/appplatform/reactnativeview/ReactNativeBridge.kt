package com.lmig.uscm.digital.appplatform.reactnativeview

import android.view.View
import com.facebook.react.ReactPackage
import com.facebook.react.CompositeReactPackage
import com.facebook.react.bridge.JavaScriptModule
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ReactShadowNode
import com.facebook.react.uimanager.ViewManager
import com.lmig.uscm.digital.appplatform.appmanager.CommonEventManager
import java.util.*

/**
 * React Native Bridge
 *
 * A React Package used to expose a collection of [NativeModule] classes to the React Native JavaScript code
 * We use this to expose an [EventManager] which contains a number of App Platform functions to the React Native JavaScript code
 *
 * @param [eventMan] The [CommonEventManager] for the React Native module
 */
class ReactNativeBridge (val eventMan: CommonEventManager) : ReactPackage {

    /**
     * Overridden implementation of the [ReactPackage.createNativeModules] function
     *
     * @param [reactContext] The current [ReactApplicationContext]
     * @return A collection of [NativeModule] items
     */
    override fun createNativeModules(reactContext: ReactApplicationContext?): MutableList<NativeModule> {
        val modules = ArrayList<NativeModule>()
        modules.add(EventManager(reactContext = reactContext, eventMan = eventMan))
        reactContext?.let { reactContext ->
            modules.add(AuthModule(reactContext = reactContext))
            modules.add(BiometricModule(reactContext = reactContext))
        }
        return modules
    }

    /**
     * Overridden implementation of the [ReactPackage.createViewManagers] function
     *
     * @param [reactContext] The current [ReactApplicationContext]
     * @return A collection of [ViewManager] items
     */
    override fun createViewManagers(reactContext: ReactApplicationContext?):
            MutableList<ViewManager<View, ReactShadowNode<ReactShadowNode<*>>>> = Collections.emptyList()
}