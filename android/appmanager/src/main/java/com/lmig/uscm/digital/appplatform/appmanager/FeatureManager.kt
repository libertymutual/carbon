package com.lmig.uscm.digital.appplatform.appmanager

import android.content.Context
import android.content.Intent

/**
 * Feature Manager
 *
 * Class representing the Feature Manager
 *
 * @param [features] A [MutableList] of [Feature] modules used in the app
 * @param [defaultFeatureName] The name of the default (initial) [Feature] to be displayed
 * @param [context] The current Android [Context]
 *
 * @property [currentFeatureName] The name of the current [Feature] displayed
 */
class FeatureManager(val features: MutableList<Feature>, val defaultFeatureName: String, val context: Context) {

    var currentFeatureName = defaultFeatureName

    /**
     * Updates a feature with new config based on an updated [Navigation] object
     *
     * @param [feature] The [Feature] to be updated
     * @param [nav] A [Navigation] object containing the updates config data
     */
    fun updateFeature(feature: Feature, nav: Navigation){
        if (feature.config?.viewConfig?.config is ReactNativeViewConfig) {

            val conf = (feature.config?.viewConfig as ViewConfig).config as ReactNativeViewConfig

            val navData = nav.data as ReactNav

            // Edit the values of the current feature
            conf.moduleName = navData.moduleName
            conf.initialProperties = navData.initialProperties
            conf.launchOptions = navData.launchOptions

            feature.setup()
        }
    }

    /**
     * Displays a feature
     *
     * @param [feature] The [Feature] to be displayed
     */
    fun display(feature: Feature){
        // This should be part of feature setup, if the intention is to always run on the App's Context
        feature.intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        
        currentFeatureName = feature.name
        context.startActivity(feature.intent)
    }

    /**
     * Displays a feature with animation
     *
     * @param [feature] The [Feature] to be displayed
     * @param [animation] The animation type to be used
     */
    fun displayWithAnimation(feature: Feature, animation: String?){
        //TODO: Add animation
        currentFeatureName = feature.name
        context.startActivity(feature.intent)
    }

    /**
     * Merges updated [FeatureConfig] objects into the existing collection of [Feature] objects
     *
     * @param [featureConfig] An updated [MutableList] of [FeatureConfig] objects to be merged
     */
    fun mergeConfig(featureConfig: MutableList<FeatureConfig>){
        for (feature in features) {
            featureConfig.find { it.name == feature.name }?.let { featureConfig ->
                feature.config = featureConfig
            }
        }
    }

    /**
     * Merges updated [ViewConfig] objects into the existing collection of [ViewConfig] objects
     *
     * @param [viewConfig] An updated [MutableList] of [ViewConfig] objects to be merged
     */
    fun setupViews(viewConfig: MutableList<ViewConfig>){
        for (feature in features) {
            viewConfig.find { it.name == feature.config?.name }?.let { viewConfig ->
                feature.config?.viewConfig = viewConfig
            }
            feature.setup()
        }
    }

    /**
     * Gets the default [Feature] name
     *
     * @return The default [Feature] name
     */
    fun getDefaultFeature(): Feature? {
        return features.find { it.name == defaultFeatureName }
    }

    /**
     * Gets a [Feature] by name
     *
     * @param [name] The name of the feature to be returned
     *
     * @return A [Feature] with a matching name
     */
    fun getFeatureByName(name: String): Feature? {
        return features.find { it.name == name }
    }

}
