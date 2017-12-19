package com.lmig.uscm.digital.appplatform.appmanager

/**
 * Common Event Manager
 *
 * An interface used to define a common set of functions & properties which must be implemented by any DSS Event Manager
 *
 * @property [app] An instance of a DSS [AppPlatformApplication] component
 */
interface CommonEventManager {
    val app: AppPlatformApplication

    /**
     * Navigates the user from the React Native View to any other module
     *
     * @param [featureName] The name of the feature to navigate to
     * @param [options] A map of navigation options
     */
    fun navigateFromReactNative(featureName: String, options: Map<String, Any>) {

        var nav: Navigation? = null

        app.appManager?.featureManager?.getFeatureByName(name = featureName)?.config?.viewConfig?.name.let {
            when(it) {
                "ReactNative" -> {
                    val reactNav = ReactNav(attributes = options)
                    nav = Navigation(featureName = featureName, data = reactNav)
                }

                "Webview" -> {
                    val webviewNav = WebviewNav(attributes = options)
                    nav = Navigation(featureName = featureName, data = webviewNav)
                }
                // case "Cordova"
                // case "Native"
            }
            nav?.let {
                app.appManager?.navigationManager?.navigate(nav = it)
            }
        }
    }

}