//
//  NavigationDelegate.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//
import WebKit
import Cordova
import XCGLogger
import lmig_webview_engine_plugin

class NavigationDelegate: NSObject, WKNavigationDelegate {
    // MARK: - Public Properties
    var navigationAction = NavigationAction()

    var webEngine: LMIGWebEngine? {
        didSet {
            navigationAction.webEngine = webEngine
        }
    }

    let logger = XCGLogger.default // Global logger access point
    let navigationPolicy: NavigationPolicy

    // MARK: - WKNavigationDelegate Methods

    init(navigationPolicy: NavigationPolicy) {
        self.navigationPolicy = navigationPolicy
        super.init()
    }

    /**
     Handles policy navigation by calling defaultResourcePolicyForURL
     */
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        logger.info("Deciding policy for URL: \(String(describing: url))")

        // Handle all types of urls (tel:, sms:), and requests to load a url in the main webview.
        let policy = self.navigationPolicy.getPolicy(url: url!)
        return self.navigationPolicy.allowNavigationForPolicy(policy: policy, andUrl: url!) ?
            decisionHandler(WKNavigationActionPolicy.allow) : decisionHandler(WKNavigationActionPolicy.cancel)
    }

    /**
     Manages failed navigation
     */
    func webView(theWebView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        logger.error("Failed to load webpage with error: \(error.localizedDescription)")
    }

    /**
     Called when a mainframe page load starts
     */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        logger.info("Started navigation - \(navigation.description)")

        NotificationCenter.default.post(Notification(name: Notification.Name.CDVPluginReset, object: webView))
    }

    /**
     Called when load completes
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        logger.info("Finished navigation - \(navigation.description)")

        NotificationCenter.default.post(Notification(name: NSNotification.Name.CDVPageDidLoad, object: webView))
    }

}
