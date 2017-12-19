//
//  NavigationAction.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCGLogger
import lmig_webview_engine_plugin

/// Errors generated by NavigationAction class
enum NavigationActionError: Error {
    case unableToLaunchModal
}

public class NavigationAction: NSObject {
    let kLogger = XCGLogger.default

    var webEngine: LMIGWebEngine?

    // Navigate back to the app's home screen
    public func goHome() {
        let nav = Navigation(featureName: "Default")
        NotificationCenter.default.post(name: .navigate, object: nav)
    }

    // Triggers JavaScript method that displays user is logged out
    public func showLoggedOutMessage() {
        guard let webEngine = webEngine else {
            kLogger.error("WebViewEngine not set")
            return
        }

        webEngine.evaluateJavaScript("SalesAndService.showLoggedOutMessage();", completionHandler: nil)
    }

    public func launchModalWebView(url: URL) throws {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)

//        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
//            kLogger.error("Failed to retrieve active view controller")
//            throw NavigationActionError.unableToLaunchModal
//        }

//        let rawViewController = storyboard.instantiateViewController(withIdentifier: "ModalWebViewController")

//        guard let modalWebViewController = rawViewController as? ModalWebViewController else {
            kLogger.error("Failed to initialize Modal Web View Controller")
            throw NavigationActionError.unableToLaunchModal
//        }
//
//        modalWebViewController.url = url
//        kLogger.info("Sending user to ModalWebView with URL: \(url)")
//        rootViewController.present(modalWebViewController, animated: true, completion: nil)
    }

    public func launchSafari(url: URL) {
        kLogger.info("Sending user to Safari with URL: \(url)")
        if UIApplication.shared.canOpenURL(url) {
            let navigationAlert = NavigationAlert()
            navigationAlert.displayExitAlertForURL(exitUrl: url)
        } else {
            kLogger.error("Unable to open URL in Safari: \(url)")
        }
    }

}
