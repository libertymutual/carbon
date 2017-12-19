package com.lmig.uscm.digital.appplatform.webviewview

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity

import android.webkit.WebView
import com.lmig.uscm.digital.appplatform.appmanager.AppPlatformApplication
import com.lmig.uscm.digital.appplatform.appmanager.WebviewViewConfig

/**
 * Webview View
 *
 * A Webview Android [AppCompatActivity] which represents the core functionality of the Webview View Module
 *
 * @property [rootView] The [WebView] required by WebviewView
 */
class WebviewView : AppCompatActivity() {
    private var rootView: WebView? = null
    private var feature: WebviewFeature? = null

    /**
     * Overridden implementation of the Android [AppCompatActivity.onCreate] function
     *
     * @param [savedInstanceState] The saved instance [Bundle]
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        this.feature = getCurrentFeature()

        rootView = WebView(this)
        var url = intent.getStringExtra("url")
        this.feature?.let { feature ->
            rootView!!.setWebViewClient(PlatformWebViewClient(feature.navigationPolicy))
            rootView!!.getSettings().setJavaScriptEnabled(true)
        }
        launchWebviewView()

    }

    /**
     * Launches the Webview View
     */
    private fun launchWebviewView () {

        this.feature?.config?.let { config ->
            val url = (config.viewConfig.config as WebviewViewConfig).url
            rootView!!.loadUrl(url)
            setContentView(rootView)
        }

    }

    /**
     * Gets the current feature fro
     */
    private fun getCurrentFeature() : WebviewFeature? {
        val app = applicationContext as AppPlatformApplication

        app.appManager?.let { appManager ->
            return appManager.featureManager.getFeatureByName(appManager.featureManager.currentFeatureName) as WebviewFeature
        }
        return null
    }


    /**
     * Overridden implementation of the Android [AppCompatActivity.onActivityResult] function
     *
     * Used to handle result of requesting App Overlay Permissions
     *
     * @param [requestCode] The request code of the Activity result being handled
     * @param [resultCode] The result code of the Activity result being handled
     * @param [data] The original [Intent]
     */
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        launchWebviewView()
    }

}
