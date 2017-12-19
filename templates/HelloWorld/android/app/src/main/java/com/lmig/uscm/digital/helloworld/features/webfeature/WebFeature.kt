package com.lmig.uscm.digital.helloworld.features.webfeature

import android.content.Context
import android.content.Intent

import com.lmig.uscm.digital.appplatform.appmanager.FeatureConfig
import com.lmig.uscm.digital.appplatform.webviewview.NavigationPolicy
import com.lmig.uscm.digital.appplatform.webviewview.WebviewFeature
import com.lmig.uscm.digital.appplatform.webviewview.WebviewView

/**
 * Web Feature
 *
 * Native Android component used to configure the webview Feature
 *
 * @param [config] The [FeatureConfig] representing the config for the Feature
 * @param [context] The current Android [Context]
 *
 * @property [intent] An Android [Intent] used to launch the Activity for this Feature
 */
class WebFeature (override var config: FeatureConfig?, override val context: Context) : WebviewFeature {
    override val name = "Web"
    override val url = "https://www.google.com/"
    override var intent = Intent(context, WebviewView::class.java)
    override var navigationPolicy = NavigationPolicy()

    /**
     * Performs initial setup of the Feature
     */
    override fun setup() {
        setupWebview()
    }


}
