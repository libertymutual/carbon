//
//  NavigationManager.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation

public struct Navigation {
    public var featureName: String
    public var data: NavType?

    public init(featureName: String, data: NavType) {
        self.featureName = featureName
        self.data = data
    }

    public init(featureName: String) {
        self.featureName = featureName
    }
}

public protocol NavType {
    init(attributes: [String: Any]) throws
}

/// Cordova specific navigation type
public struct CordovaNav: NavType {
    public var url: String?

    public init(attributes: [String: Any]) throws {
        guard let url = attributes["url"] as? String else {
            throw ValidationError.missing("url")
        }

        self.url = url
    }
}

/// React Native specific navigation type
public struct ReactNav: NavType {
    public var moduleName: String
    public var initialProperties: [AnyHashable: Any]?
    public var launchOptions: [AnyHashable: Any]?

    public init(attributes: [String: Any]) throws {
        guard let moduleName = attributes["moduleName"] as? String else {
            throw ValidationError.missing("moduleName")
        }

        // optional
        let initialProperties = attributes["initialProperties"] as? [AnyHashable: Any]
        let launchOptions = attributes["launchOptions"] as? [AnyHashable: Any]

        self.moduleName = moduleName
        self.initialProperties = initialProperties
        self.launchOptions = launchOptions
    }

}

/// Compares two `ReactNav` objects
extension ReactNav: Equatable {
    public static func == (lhs: ReactNav, rhs: ReactNav) -> Bool {

        var initialPropertiesEqual = false
        var launchOptionsEqual = false

        // These options are not full-proof comparable - to be updated with extra types when needed
        // Currently, it allows only list of params with the same type
        if lhs.initialProperties == nil && rhs.initialProperties == nil {
            initialPropertiesEqual = true
        } else if let lInitProp = lhs.initialProperties as? [AnyHashable: String],
            let rInitProp = rhs.initialProperties as? [AnyHashable: String] {
            initialPropertiesEqual = lInitProp == rInitProp
        } else if let lInitProp = lhs.initialProperties as? [AnyHashable: Int],
            let rInitProp = rhs.initialProperties as? [AnyHashable: Int] {
            initialPropertiesEqual = lInitProp == rInitProp
        }

        if lhs.launchOptions == nil && rhs.launchOptions == nil {
            launchOptionsEqual = true
        } else if let lLaunchOptions = lhs.launchOptions as? [AnyHashable: String],
            let rLaunchOptions = rhs.launchOptions as? [AnyHashable: String] {
            launchOptionsEqual = lLaunchOptions == rLaunchOptions
        } else if let lLaunchOptions = lhs.launchOptions as? [AnyHashable: Int],
            let rLaunchOptions = rhs.launchOptions as? [AnyHashable: Int] {
            launchOptionsEqual = lLaunchOptions == rLaunchOptions
        }

        return lhs.moduleName == rhs.moduleName
            && initialPropertiesEqual
            && launchOptionsEqual
    }
}

/// Used for navigation between features
open class NavigationManager {
    let featureManager: FeatureManager

    /**
     Initialization method for the `NavigationManager`. After everything is set to local instance,
     it initiates default feature
     
     - parameter featureManager: Sets `FeatureManager` to the instance
     */
    public init(featureManager: FeatureManager) {
        self.featureManager = featureManager

        // Register to receive notification
        NotificationCenter.default.addObserver(forName: .navigate, object: nil, queue: OperationQueue.main, using: navigate)

        do {
            try self.startDefaultFeature()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    /**
     Starts the default feature on initialization
     
     */
    func startDefaultFeature() throws {
        let defaultFeature = self.featureManager.getDefaultFeature()
        if defaultFeature == nil {
            throw ValidationError.invalid("No default feature specified")
        } else {
            self.featureManager.display(feature: defaultFeature!)
        }
    }

    public func goTo(nav: Navigation) {
        // Post notification
        NotificationCenter.default.post(name: .navigate, object: nav)
    }

    /**
     Navigation callback to be passed to the EventBus
     
     - parameter notification: passes a `Notification` containing the `Navigation` object and any data to be passed
     */
    func navigate(notification: Notification) {
        if let nav = notification.object as? Navigation {
            if let feature = featureManager.getFeatureByName(name: nav.featureName) {
                featureManager.updateFeature(feature: feature, nav: nav)
                featureManager.display(feature: feature)
            }
        }
    }

    /**
     Deinitialization method for the `NavigationManager`. Removes the navigate callback from the NotificationCenter
     */
    deinit {
        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: .navigate, object: nil)
    }

}

/// Name for navigation events:
extension Notification.Name {
    static let navigate = Notification.Name("NAVIGATE")
}
