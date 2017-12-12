//
//  EventManager
//  HelloWorld
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
import AppPlatform.ReactNativeView
import AppPlatform.AppManager
import React

@objc(EventManager)
open class EventManager: NSObject {
    weak var delegate = UIApplication.shared.delegate as? AppDelegate

    func callNav(nav: Navigation) {
        // Move to a background thread to do some long running work
        DispatchQueue.global(qos: .userInitiated).sync {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.sync {
                self.delegate?.appManager?.navigationManager.goTo(nav: nav)
            }
        }
    }

    @objc
    public func navigateFromReactNative(_ name: String, object: NSDictionary) { // [String: Any]
        var nav: Navigation? = nil

        if let feature = self.delegate?.appManager?.featureManager.getFeatureByName(name: name),
            let viewName = feature.config?.viewConfig?.name {
            switch viewName {
            case "ReactNative":
                if let reactNav = try? ReactNav(attributes: (object as? [String: Any])!) {
                    nav = Navigation(featureName: name, data: reactNav)
                } else {
                    print("Navigation object is wrong!")
                }
            case "Cordova":
                if var cordovaNav = try? CordovaNav(attributes: (object as? [String: Any])!) {
                    if cordovaNav.url!.contains("file")
                        || cordovaNav.url!.contains("http")
                        || cordovaNav.url!.contains("https") {
                        nav = Navigation(featureName: name, data: cordovaNav)
                    } else if let cordovaViewController = (feature.view?.viewController as? CordovaViewController),
                        let url = cordovaViewController.commandDelegate.path(forResource: cordovaNav.url!) {
                        cordovaNav.url = URL(fileURLWithPath: url).absoluteString
                        nav = Navigation(featureName: name, data: cordovaNav)
                    }
                } else {
                    print("Navigation object is wrong!")
                }
                // case "Native":
            // case "Webview":
            default:
                break
            }
        }

        if nav != nil {
            self.callNav(nav: nav!)
        }
    }
    @objc
    public func getBuildType(_ resolve: @escaping RCTPromiseResolveBlock,
                             rejecter reject: @escaping RCTPromiseRejectBlock) {
        resolve(self.delegate?.appManager?.config.buildType)
    }
}
