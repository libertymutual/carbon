package com.lmig.uscm.digital.helloworld.features.defaultfeature

import android.content.Context
import android.content.Intent
import com.lmig.uscm.digital.appplatform.appmanager.FeatureConfig
import com.lmig.uscm.digital.appplatform.reactnativeview.ReactNativeFeature
import com.lmig.uscm.digital.appplatform.reactnativeview.ReactNativeView

/**
 * Default Feature
 *
 * Native Android component used to configure the "Default" React Native Feature
 *
 * @param [config] The [FeatureConfig] representing the config for the Feature
 * @param [context] The current Android [Context]
 *
 * @property [intent] An Android [Intent] used to launch the Activity for this Feature
 */
class DefaultFeature (override var config: FeatureConfig?, override val context: Context) : ReactNativeFeature {
    override val name = "Default"
    override val moduleName = "DefaultModule"
    override var intent = Intent(context, ReactNativeView::class.java)
    /**
     * Performs initial setup of the Feature
     */
    override fun setup() {
        setupReactNative()
    }

}
