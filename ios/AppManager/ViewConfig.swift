//
//  ViewConfig.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation

/// Cordova specific view config
public struct CordovaViewConfig {
    public var url: URL

    /**
     Initialization method for React Native view config
     
     - parameter attributes: Takes `[String: Any]` and sets values to the instance
     - returns: `void` or throws `ValidationError` in case of problems
     */
    public init(attributes: [String: Any]) throws {
        guard let stringURL = (attributes["url"] as? String) else {
            throw ValidationError.missing("url")
        }
        guard let url = URL(string: stringURL) else {
            throw ValidationError.missing("url")
        }

        self.url = url
    }
}

/// Comparison of two different `CordovaViewConfig` instances
extension CordovaViewConfig: Equatable {
    public static func == (lhs: CordovaViewConfig, rhs: CordovaViewConfig) -> Bool {
        return lhs.url == rhs.url
    }
}

/// ReactNative specific view config
public struct ReactNativeViewConfig {
    public var bundleURL: URL // used for dev
    public var initialProperties: [AnyHashable: Any]?
    public var launchOptions: [AnyHashable: Any]?
    public var moduleName: String

    /**
     Initialization method for React Native view config
     
     - parameter attributes: Takes `[String: Any]` and sets values to the instance
     - returns: `void` or throws `ValidationError` in case of problems
     */
    public init(attributes: [String: Any]) throws {
        guard let url = attributes["bundleURL"] as? String, let bundleURL = URL(string: url) else {
            throw ValidationError.missing("bundleURL")
        }

        // optional
        let initialProperties = attributes["initialProperties"] as? [AnyHashable: Any]
        let launchOptions = attributes["launchOptions"] as? [AnyHashable: Any]

        guard let moduleName = attributes["moduleName"] as? String else {
            throw ValidationError.missing("moduleName")
        }

        self.bundleURL = bundleURL
        self.initialProperties = initialProperties
        self.launchOptions = launchOptions
        self.moduleName = moduleName
    }
}

/// Comparison of two different `ReactNativeViewConfig` instances
extension ReactNativeViewConfig: Equatable {
    public static func == (lhs: ReactNativeViewConfig, rhs: ReactNativeViewConfig) -> Bool {
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

        return lhs.bundleURL == rhs.bundleURL
            && initialPropertiesEqual
            && launchOptionsEqual
            && lhs.moduleName == rhs.moduleName
    }
}

/// View Configuration data structure
public struct ViewConfig {
    public var name: String
    public var config: Any?

    /**
     Initialization method for view config.
     Depending on the name of the view, it automatically initiates specific view config.
     (e.g. when name is "ReactNative", it will automatically initiate `ReactNativeViewConfig` 
     and store it to `this.config`)
     
     - parameter attributes: Takes `[String: Any]` and sets values to the instance
     - returns: `void` or throws `ValidationError` in case of problems
     */
    public init(attributes: [String: Any]) throws {
        guard let name = attributes["name"] as? String else {
            throw ValidationError.missing("name")
        }

        guard let config = attributes["config"] as? [String: Any] else {
            throw ValidationError.missing("config")
        }

        self.name = name

        switch name {
        case "ReactNative":
            self.config = try ReactNativeViewConfig(attributes: config)
        case "Cordova":
            self.config = try CordovaViewConfig(attributes: config)
        default:
            throw ValidationError.invalid("ViewConfigName")
        }
    }
}

/// Compares if two instances of `ViewConfig` are the same
extension ViewConfig: Equatable {
    public static func == (lhs: ViewConfig, rhs: ViewConfig) -> Bool {
        var configEqual = false
        if let lc = lhs.config as? ReactNativeViewConfig, let rc = rhs.config as? ReactNativeViewConfig {
            configEqual = lc == rc
        } else if let lc = lhs.config as? CordovaViewConfig, let rc = rhs.config as? CordovaViewConfig {
            configEqual = lc == rc
        } else if lhs.config == nil && rhs.config == nil {
            configEqual = true
        }

        return lhs.name == rhs.name && configEqual
    }
}
