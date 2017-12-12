//
//  WebFeature.swift
//  HelloWorld
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//
import AppPlatform.AppManager
import AppPlatform.CordovaView

/// Sample Web feature with Cordova view
class WebFeature: CordovaFeature, Feature {
    var name: String = "Web"
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
        try self.setupCordova()
    }
}
