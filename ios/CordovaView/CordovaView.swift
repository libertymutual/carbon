//
//  CordovaView.swift
//  CordovaView
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
import React

/// React Native View implementation
final public class CordovaView: View {
    public var viewController: UIViewController?
    public var name: String = "Cordova"

    public init() {}

    /**
     Loads the RN with initial settings and sets it to the view of `UIViewController`

     - parameter config: RN view config
     - returns: `UIViewController` with RN view
     */
    public func loadViewController(config: ViewConfig) -> UIViewController {
        guard let cordovaConfig = config.config as? CordovaViewConfig else {
            return UIViewController()
        }

        let rootViewController = CordovaViewController(cordovaViewConfig: cordovaConfig)
        return rootViewController
    }
}
