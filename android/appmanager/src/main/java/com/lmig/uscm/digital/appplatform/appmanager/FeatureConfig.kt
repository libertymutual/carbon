package com.lmig.uscm.digital.appplatform.appmanager

/**
 * Feature Config
 *
 * Class representing the configuration of an App Feature
 *
 * @param [attributes] A map of configuration items
 *
 * @property [name] The feature name
 * @property [viewConfig] The [ViewConfig] representing the view config for the Feature
 */
class FeatureConfig(attributes: Map<String, Any>) {

    val name = attributes.get(key = "name") as String
    var viewConfig = ViewConfig(attributes = (attributes.get(key = "viewConfig") as Map<String, Any>))
    var platform = attributes.get(key = "platform") as String?

    /**
     * Overridden implementation of the equals function
     *
     * Used to test comparison of two [FeatureConfig] objects
     *
     * @param [other] The item to be tested for equality. Usually another [FeatureConfig] (but not necessarily)
     *
     * @return A [Boolean] indicating if the two [FeatureConfig] objects are equal
     */
    override fun equals(other: Any?): Boolean{
        if (this === other) return true
        if (other?.javaClass != javaClass) return false

        other as FeatureConfig

        return name == other.name && viewConfig == other.viewConfig && platform == other.platform
    }
}