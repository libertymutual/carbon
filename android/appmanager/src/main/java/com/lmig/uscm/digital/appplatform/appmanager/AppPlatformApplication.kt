package com.lmig.uscm.digital.appplatform.appmanager

import android.app.Application
import android.support.v4.content.LocalBroadcastManager
import com.lmig.uscm.digital.appplatform.AppPlatform

/**
 * App Platform Application
 *
 * This is the main application class used for orchestrating all other activities & components
 * This should NOT be used directly, but instead should be subclassed
 *
 * @property [appConfigFilename] The name of the app config json file (typically "app.json")
 * @property [defaultFeature] The name of the default (initial) [Feature] to be displayed
 * @property [appPlatform] An instance of an [AppPlatform] component
 * @property [featuresList] A list of [Feature] components used within the app
 * @property [appConfig] An instance of an [AppConfig] component
 * @property [appManager] An instance of an [AppManager] component
 * @property [eventManager] An instance of an [CommonEventManager] component
 */
open class AppPlatformApplication : Application() {

    // Set this to the value of your app config json file
    open val appConfigFilename = "app.json"

    // Set this to the value of your default/launch feature
    open val defaultFeature = "Default"

    var appPlatform = AppPlatform()
    val featuresList = ArrayList<Feature>()
    var appConfig: AppConfig? = null
    var appManager: AppManager? = null
    open val eventManager: CommonEventManager? = null

    /**
     * Initializes the app platform
     */
    fun initializeAppPlatform() {
        appConfig = AppConfig(filename = appConfigFilename, context = this)
        val broadcastManager = getBroadcastManager()

        val featureManager = FeatureManager(features = featuresList, defaultFeatureName = defaultFeature, context = this)
        appManager = AppManager(featureManager = featureManager, config = appConfig as AppConfig, broadcastManager = broadcastManager)

        // Note: Once App Platform has been initialized, a call will be made from the MainActivity call to display the default feature.
        // This is done specifically in this location so that the default feature will be relaunched on AppResume
    }

    /**
     * Returns a shared instance of [LocalBroadcastManager]
     *
     * @return A shared instance of [LocalBroadcastManager]
     */
    fun getBroadcastManager() : LocalBroadcastManager {
        return LocalBroadcastManager.getInstance(this)
    }
}
