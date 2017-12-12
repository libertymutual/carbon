//
//  ReactNativeFeature.swift
//  ReactNativeView
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
//import AppManager

public protocol ReactNativeFeature: Feature {
    var config: FeatureConfig? { get set }
    var view: View? {get set}
}

extension ReactNativeFeature {
    /**
     Initialization method for setting feature config a view. Implements RN view
     
     - returns: throws `ValidationError` if view not loaded, `void` otherwise
     */
    public func setupReactNative() throws {
        if let viewConfig = self.config?.viewConfig {
            self.view = ReactNativeView(config: viewConfig)
        } else {
            throw ValidationError.invalid("View not loaded")
        }
    }

    public func navigate() {
        do {
            // refresh RN's bridge with new config
            try self.setup()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
