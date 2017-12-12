package com.lmig.uscm.digital.helloworld

import android.app.Application
import com.lmig.uscm.digital.appplatform.appmanager.*
import com.lmig.uscm.digital.helloworld.features.defaultfeature.DefaultFeature
import com.lmig.uscm.digital.helloworld.features.secondfeature.SecondFeature

/**
 * Main Application
 *
 * This is the main application class used for orchestrating all other activities & components
 *
 * @property [appConfigFilename] The name of the app config json file (typically "app.json")
 * @property [defaultFeature] The name of the default (initial) [Feature] to be displayed
 * @property [eventManager] An instance of a DSS [CommonEventManager] subclass
 */
class MainApplication : AppPlatformApplication(){

    // Set this to the value of your app config json file
    override val appConfigFilename = "app.json"

    // Set this to the value of your default/launch feature
    override val defaultFeature = "Default"

    // Set this to an instance of your CommonEventManager subclass
    override val eventManager: CommonEventManager = AppEventManager(app = this)

    /**
     * Overridden implementation of the Android [Application.onCreate] function
     */
    override fun onCreate() {
        super.onCreate()

        // Initialize your features here
        featuresList.add(DefaultFeature(config = null, context = this))
        featuresList.add(SecondFeature(config = null, context = this))

        this.initializeAppPlatform()
    }
}
