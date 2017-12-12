package com.lmig.uscm.digital.appplatform.appmanager

/**
 * View Config
 *
 * Class representing a View Configuration
 *
 * @param [attributes] A map of configuration items
 *
 * @property [name] The name of the view
 * @property [config] The configuration for the view
 */
class ViewConfig(attributes: Map<String, Any>) {

    val name = attributes.get(key = "name") as String
    var config: Any

    /**
     * Initializes the View Config
     */
    init {
        config = attributes.get(key = "config") as Map<String, Any>

        when(name) {
            "ReactNative" -> {
                config = ReactNativeViewConfig(attributes = (config as Map<String, Any>))
            }
        }
    }

    /**
     * Overridden implementation of the equals function
     *
     * Used to test comparison of two [ViewConfig] objects
     *
     * @param [other] The item to be tested for equality. Usually another [ViewConfig] (but not necessarily)
     *
     * @return A [Boolean] indicating if the two [ViewConfig] objects are equal
     */
    override fun equals(other: Any?): Boolean{
        if (this === other) return true
        if (other?.javaClass != javaClass) return false

        other as ViewConfig

        return name == other.name && config.equals(other.config)
    }

}