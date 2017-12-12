//
//  AppManager.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//
import UIKit

/// Main wrapper for all the features of the new platform
open class AppManager {
    public var featureManager: FeatureManager
    public var config: AppConfig
    public var navigationManager: NavigationManager

    /**
     Initialization method for the `AppManager`. After everything is set to local instance,
     it initiates default feature
     
     - parameter featureManager: Sets `FeatureManager` to the instance
     - parameter config: Sets `AppConfig` to the instance
     */
    public init (featureManager: FeatureManager, config: AppConfig) {
        self.featureManager = featureManager
        self.config = config

        self.featureManager.mergeConfig(featureConfig: self.config.features)
        self.featureManager.setupViews(viewConfig: self.config.views)
        self.navigationManager = NavigationManager(featureManager: self.featureManager)
    }
}
