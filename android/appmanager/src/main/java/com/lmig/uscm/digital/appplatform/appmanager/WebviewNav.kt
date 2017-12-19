package com.lmig.uscm.digital.appplatform.appmanager

/**
 * Webview Nav
 *
 * Class representing the Webview [NavType]
 *
 * @param [attributes] A map of configuration items
 *
 * @property [url] The [URL] where Webview should navigate
 */
class WebviewNav(val attributes: Map<String, Any>) : NavType{
    var url = attributes.get(key = "url") as String

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

        other as WebviewNav

        return url == other.url
    }
}