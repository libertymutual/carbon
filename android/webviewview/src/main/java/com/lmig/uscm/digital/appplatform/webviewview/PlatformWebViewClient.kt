package com.lmig.uscm.digital.appplatform.webviewview


import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient

/**
 * Custom implementation of the [WebViewClient]
 *
 * Overridden methods enable intercepting URLs in order to customize different behavior per URL.
 */
class PlatformWebViewClient(internal var navigationPolicy: NavigationPolicy) : WebViewClient() {

    /**
     * Give the host application a chance to take over the control when a new url is about to be loaded in the current WebView.
     * If WebViewClient is not provided, by default WebView will ask Activity Manager to choose the proper handler for the url.
     * If WebViewClient is provided, return true means the host application handles the url,
     * while return false means the current WebView handles the url.
     * This method is not called for requests using the POST "method".
     */
    override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
        if (request != null) {
            val policy = navigationPolicy.getPolicy(request.url)
            return !navigationPolicy.allowNavigationForPolicy(policy, request.url)
        }
        return false
    }
}