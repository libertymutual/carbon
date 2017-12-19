package com.lmig.uscm.digital.appplatform.appmanager

/**
 * Webview View Config
 *
 * Class representing the configuration of a Webview View
 *
 * @param [attributes] A map of configuration items
 *
 * @property [url] The [URL] where Webview should navigate
 */
class WebviewViewConfig(val attributes: Map<String, Any>) {
    var url = attributes.get(key = "url") as String

    /**
     * Overridden implementation of the equals function
     *
     * Used to test comparison of two [WebviewViewConfig] objects
     *
     * @param [other] The item to be tested for equality. Usually another [WebviewViewConfig] (but not necessarily)
     *
     * @return A [Boolean] indicating if the two [WebviewViewConfig] objects are equal
     */
    override fun equals(other: Any?): Boolean{
        if (this === other) return true
        if (other?.javaClass != javaClass) return false

        other as WebviewViewConfig

        return url == other.url
    }
}
