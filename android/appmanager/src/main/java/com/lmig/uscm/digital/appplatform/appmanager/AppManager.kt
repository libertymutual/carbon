package com.lmig.uscm.digital.appplatform.appmanager

import android.support.v4.content.LocalBroadcastManager

/**
 * App Manager
 *
 * Class representing the Application Manager
 *
 * @param [featureManager] An instance of a DSS [FeatureManager] component
 * @param [config] An instance of a DSS [AppConfig] component
 * @param [broadcastManager] An instance of a [LocalBroadcastManager]
 *
 * @property [navigationManager] An instance of a DSS [NavigationManager] component
 */
class AppManager(val featureManager: FeatureManager, val config: AppConfig, val broadcastManager: LocalBroadcastManager) {

    val navigationManager: NavigationManager

    /**
     * Initializes the App Manager
     */
    init {
        featureManager.mergeConfig(featureConfig = config.features)
        featureManager.setupViews(viewConfig = config.views)
        navigationManager = NavigationManager(featureManager = featureManager, broadcastManager = broadcastManager)
    }
}