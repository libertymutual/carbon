//
//  CordovaFeature.swift
//  CordovaView
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
import WebKit

public protocol CordovaFeature: Feature {
    var config: FeatureConfig? { get set }
    var view: View? {get set}
}

extension CordovaFeature {
    /**
     Initialization method for setting feature config a view. Implements Cordova view
     
     - returns: throws `ValidationError` if view not loaded, `void` otherwise
     */
    public func setupCordova() throws {
        if let viewConfig = self.config?.viewConfig {
            self.view = CordovaView(config: viewConfig)
        } else {
            throw ValidationError.invalid("View not loaded")
        }
    }

    /**
     Used to match URL of the webview with new URL set to the view config
     */
    public func navigate() {
        if let cordovaViewConfig = self.config?.viewConfig?.config as? CordovaViewConfig {
            if let cdvViewController = self.view?.viewController as? CordovaViewController {
                if let webView = cdvViewController.webView as? WKWebView {
                    // Mini optimization - when trying to open the same URL as currently loaded, skip reload
                    if webView.url != cordovaViewConfig.url {
                        cdvViewController.loadURL(url: cordovaViewConfig.url)
                    }
                }
            }
        }
    }
}
