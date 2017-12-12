package com.lmig.uscm.digital.appplatform.appmanager

import android.content.Intent

/**
 * App Interface
 *
 * An interface used to define a common set of functions & properties which must be implemented by any DSS Feature
 *
 * @property [name] The name of the current component
 * @property [config] The [FeatureConfig] representing the config for the Feature
 * @property [intent] An Android [Intent] used to launch the Activity for this Feature
 */
interface Feature {
    val name: String
    var config: FeatureConfig?
    val intent: Intent

    /**
     * Performs initial setup of the Feature
     */
    fun setup()
}