package com.lmig.uscm.digital.appplatform.appmanager

import java.net.URL

/**
 * React Native View Config
 *
 * Class representing the configuration of a React Native View
 *
 * @param [attributes] A map of configuration items
 *
 * @property [bundleURL] The [URL] of the React Native JS bundle
 * @property [initialProperties] A map of initial properties for the [ViewConfig]
 * @property [launchOptions] A map of launch options for the [ViewConfig]
 * @property [moduleName] The name of the React Native module
 */
class ReactNativeViewConfig(val attributes: Map<String, Any>){

    var bundleURL = URL(attributes.get(key = "bundleURL") as String)
    var initialProperties = attributes.get(key = "initialProperties") as Map<String, Any>?
    var launchOptions = attributes.get(key = "launchOptions") as Map<String, Any>?
    var moduleName = attributes.get(key = "moduleName") as String

    /**
     * Overridden implementation of the equals function
     *
     * Used to test comparison of two [ReactNativeViewConfig] objects
     *
     * @param [other] The item to be tested for equality. Usually another [ReactNativeViewConfig] (but not necessarily)
     *
     * @return A [Boolean] indicating if the two [ReactNativeViewConfig] objects are equal
     */
    override fun equals(other: Any?): Boolean{
        if (this === other) return true
        if (other?.javaClass != javaClass) return false

        other as ReactNativeViewConfig

        return bundleURL == other.bundleURL && initialProperties == other.initialProperties && launchOptions == other.launchOptions && moduleName == other.moduleName
    }
}