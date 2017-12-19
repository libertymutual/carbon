package com.lmig.uscm.digital.appplatform.webviewview

import android.content.Context
import com.lmig.uscm.digital.appplatform.appmanager.Feature

/**
 * React Native Feature
 *
 * An interface used to define a common set of functions & properties which must be implemented by any React Native Features
 *
 * @property [context] The current Android [Context]
 * @property [url] URL for the webview
 */
interface WebviewFeature : Feature {
    val context: Context
    val url: String
    val navigationPolicy: NavigationPolicy

    /**
     * Performs initial setup of the Webview Feature
     */
    fun setupWebview() {
        intent.putExtra("url", url)
    }
}