//
//  DefaultFeature.swift
//  HelloWorld
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import AppPlatform.AppManager
import AppPlatform.ReactNativeView

/// Default feature with RN view
class DefaultFeature: ReactNativeFeature, Feature {
    var name: String = "Default"
    var config: FeatureConfig?
    var view: View?

    // Init is required to conform protocol
    required init() {}

    /**
     Initialization method for setting feature config a view. Implements RN view

     - returns: throws `ValidationError` if view not loaded, `void` otherwise
     */
    func setup() throws {
        // use default extension implementation
        try self.setupReactNative()
    }

}
