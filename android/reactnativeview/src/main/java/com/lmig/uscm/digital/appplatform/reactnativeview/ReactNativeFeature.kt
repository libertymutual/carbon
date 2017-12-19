package com.lmig.uscm.digital.appplatform.reactnativeview

import android.content.Context
import android.content.Intent
import com.lmig.uscm.digital.appplatform.appmanager.Feature

/**
 * React Native Feature
 *
 * An interface used to define a common set of functions & properties which must be implemented by any React Native Features
 *
 * @property [context] The current Android [Context]
 * @property [moduleName] The name of the current module
 */
interface ReactNativeFeature : Feature {
    val context: Context
    val moduleName: String

    /**
     * Performs initial setup of the React Native Feature
     */
    fun setupReactNative() {
        intent.putExtra("moduleName", moduleName)
    }
}