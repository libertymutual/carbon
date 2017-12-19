package com.lmig.uscm.digital.appplatform.webviewview

import android.net.Uri

/**
 * Navigation policy is a rule based engine that determines which URL should be loaded, blocked
 * or trigger another behaviour. Platform contains the default implementation which can be
 * adjusted to the needs of specific app by extending this class.
 */
open class NavigationPolicy {

    /**
     * Get policy for current URL
     *
     * @param [Uri] The URL which is currently being loaded
     *
     * @return A [PolicyResponse] that should be returned depending on [Uri]
     */
    open fun getPolicy(url: Uri) : PolicyResponse{
        if (url.scheme == null) {
            return PolicyResponse.APP
        }
        return when(url.scheme) {
            "http", "https" -> handleHttp(url)
            else -> handleIntent(url)
        }
    }

    /**
     * Handles intents for given URL
     *
     * @param [Uri] The URL which is currently being loaded
     *
     * @return A [PolicyResponse] that should be returned depending on [Uri]
     */
    open fun handleIntent(url: Uri) : PolicyResponse{
        if (url.scheme == null) {
            return PolicyResponse.APP
        }

        return when(url.scheme) {
            "about", "gap", "file" -> PolicyResponse.APP
            else -> PolicyResponse.ALLOW_INTENT
        }
    }


    /**
     * Get policy for the current URL
     *
     * @param [Uri] The URL which is currently being loaded
     *
     * @return A [PolicyResponse] that should be returned depending on [Uri]
     */
    open fun handleHttp(url: Uri) : PolicyResponse{
        return PolicyResponse.APP
    }

    /**
     * Depending on the [PolicyResponse] and [Uri] determines should the navigation be allowed.
     *
     * @param [PolicyResponse] for the given URL
     * @param [Uri] The URL which is currently being loaded
     *
     * @return A [Boolean] that should be returned depending on [Uri] and [PolicyResponse]
     */
    open fun allowNavigationForPolicy(policy: PolicyResponse, url: Uri): Boolean {
        return true
    }

}