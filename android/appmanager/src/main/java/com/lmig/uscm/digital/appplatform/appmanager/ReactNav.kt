package com.lmig.uscm.digital.appplatform.appmanager

/**
 * React Nav
 *
 * Class representing the React Native [NavType]
 *
 * @param [attributes] A map of configuration items
 *
 * @property [moduleName] The name of the React Native module
 * @property [initialProperties] A map of initial properties for the [ViewConfig]
 * @property [launchOptions] A map of launch options for the [ViewConfig]
 */
class ReactNav(val attributes: Map<String, Any>) : NavType{

    var moduleName = attributes.get(key = "moduleName") as String
    var initialProperties = attributes.get(key = "initialProperties") as Map<String, Any>?
    var launchOptions = attributes.get(key = "launchOptions") as Map<String, Any>?

    /**
     * Overridden implementation of the equals function
     *
     * Used to test comparison of two [ReactNav] objects
     *
     * @param [other] The item to be tested for equality. Usually another [ReactNav] (but not necessarily)
     *
     * @return A [Boolean] indicating if the two [ReactNav] objects are equal
     */
    override fun equals(other: Any?): Boolean{
        if (this === other) return true
        if (other?.javaClass != javaClass) return false

        other as ReactNav

        return initialProperties == other.initialProperties && launchOptions == other.launchOptions && moduleName == other.moduleName
    }
}