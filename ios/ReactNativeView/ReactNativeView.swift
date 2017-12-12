//
//  ReactNativeView.swift
//  ReactNativeView
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
import React
//import AppManager

/// React Native View implementation
final public class ReactNativeView: View {
    public var viewController: UIViewController?
    public var name: String = "ReactNative"

    static var bridge: RCTBridge?

    public init() {}

    /**
     Loads the RN with initial settings and sets it to the view of `UIViewController`

     - parameter config: RN view config
     - returns: `UIViewController` with RN view
     */
    public func loadViewController(config: ViewConfig) -> UIViewController {
        guard let reactConfig = config.config as? ReactNativeViewConfig else {
            return UIViewController()
        }
        var jsCodeLocation = Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        if let rnBundle = Bundle.main.infoDictionary!["USE_REACT_NATIVE_BUNDLE"] as? String {
            if rnBundle != "YES" {
                jsCodeLocation = reactConfig.bundleURL
            }
        }

        // Read the details of this choice: https://github.com/facebook/react-native/issues/995
        if ReactNativeView.bridge == nil {
            ReactNativeView.bridge = RCTBridge(
                bundleURL: jsCodeLocation,
                moduleProvider: nil,
                launchOptions: reactConfig.launchOptions
            )
        }

        let rootView = RCTRootView(
            bridge: ReactNativeView.bridge!,
            moduleName: reactConfig.moduleName,
            initialProperties: reactConfig.initialProperties
        )
        let rootViewController = ReactNativeViewController()
        rootViewController.view = rootView
        return rootViewController
    }
}

public class ReactNativeViewController: UIViewController {
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
