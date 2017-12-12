//
//  Feature.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation

/// Protocol for app features
public protocol Feature: class {
    var name: String { get set }
    var config: FeatureConfig? { get set }
    var view: View? { get set }

    /**
     Initialization method required for protocol
     
     */
    init()

    /**
     Initialization method for feature config
     
     - returns: throws `ValidationError` to force class extension
     */
    func setup() throws

    /**
     Used for navigation. Uses updated feature's config for nav params.
     */
    func navigate()
}

extension Feature {
    /**
     Initialization method `DefaultFeature`
     
     - parameter config: If provided, sets `FeatureConfig` to the instance
     */
    public init(config: FeatureConfig?) {
        self.init()

        if config != nil {
            self.config = config
        }
    }
}
