//
//  AppConfig.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation

/// Configuration management for the app (views, features, platforms)
public class AppConfig {
    public var name: String = ""
    public var appVersion: String
    public var buildNumber: String
    public var core: [String] = []
    public var views: [ViewConfig] = []
    public var features: [FeatureConfig] = []
    public var platforms: [PlatformConfig] = []
    public var modules: [String: [String: String]] = [:]
    public var buildType: String = "release"

    /**
     Initialization method for the app config
     
     - parameter fileName: Takes filename, loads the JSON file and sets all the values internally
     - returns: `void` or throws `ValidationError` in case of problems
     */
    // swiftlint:disable cyclomatic_complexity
    public init(fileName: String, bundle: Bundle, appBuildType: String) throws {
        // Populate appVersion & buildNumber from the iOS Bundle
        if let appVer = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            appVersion = appVer
        } else {
            appVersion = "1.0.0"
        }
        if let buildNum = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            buildNumber = buildNum
        } else {
            buildNumber = "1"
        }
        buildType = appBuildType

        if let file = bundle.path(forResource: fileName, ofType: "json") {
            let url = URL(fileURLWithPath: file)

            let jsonData = try Data(contentsOf: url)
            if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject] {

                guard let name = json?["name"] as? String else {
                    throw ValidationError.missing("name")
                }

                guard let core = json?["core"] as? [String] else {
                    throw ValidationError.missing("core")
                }

                guard let views = json?["views"] as? [Any] else {
                    throw ValidationError.missing("views")
                }

                guard let features = json?["features"] as? [Any] else {
                    throw ValidationError.missing("features")
                }

                guard let modules = json?["modules"] as? [Any] else {
                    throw ValidationError.missing("modules")
                }

                self.name = name
                self.core = core

                try self.initViews(views: views)
                if self.views.isEmpty {
                    throw ValidationError.missing("views")
                }

                try self.initFeatures(features: features)
                if self.features.isEmpty {
                    throw ValidationError.missing("features")
                }

                try self.initModules(modules: modules)
            } else {
                throw ValidationError.invalid("JSON not parsed")
            }

        } else {
            throw ValidationError.invalid("Wrong file")
        }
    }
    // swiftlint:enable cyclomatic_complexity

    /**
     Initialization method for view config.
     Takes array of strings, converts them to `ViewConfig` structs and appends to `self.views`
     
     - parameter views: Array of strings used for convertion to `ViewConfig` structs
     - returns: `void` or throws `ValidationError` in case of problems
     */
    func initViews(views: [Any]) throws {
        for viewString in views {
            guard let viewConfig = viewString as? [String: Any],
                let view = try? ViewConfig(attributes: viewConfig) else {
                    throw ValidationError.missing("view")
            }
            self.views.append(view)
        }
    }

    /**
     Initialization method for feature config.
     Takes array of strings, converts them to `FeatureConfig` structs and appends to `self.features`
     
     - parameter features: Array of strings used for convertion to `FeatureConfig` structs
     - returns: `void` or throws `ValidationError` in case of problems
     */
    func initFeatures(features: [Any]) throws {
        for featureString in features {
            if let feat = featureString as? [String: Any] {
                // Add only features that have iOS as a platform or no platform specified
                let platform = feat["platform"] as? String
                if platform == "ios" || platform == nil {
                    if let feature = try? FeatureConfig(attributes: feat) {
                        self.features.append(feature)
                    } else {
                        throw ValidationError.missing("feature")
                    }
                }
            }
        }
    }

    /**
     Initialization method for module config.
     Takes array of strings, converts them to `ModuleConfig` structs and appends to `self.modules`
     
     - parameter modules: Array of strings used for convertion to `ModuleConfig` structs
     - returns: `void` or throws `ValidationError` in case of problems
     */
    func initModules(modules: [Any]) throws {
        for moduleString in modules {
            // TODO: Create a new type (`ModuleConfig`)
            if let module = moduleString as? [String: String] {
                if let name = module["name"] {
                    self.modules[name] = module
                } else {
                    throw ValidationError.missing("module")
                }
            } else {
                    throw ValidationError.missing("module")
            }
        }
    }

}

/// Compares 2 different `AppConfig`s
extension AppConfig: Equatable {
    public static func == (lhs: AppConfig, rhs: AppConfig) -> Bool {
        return lhs.name == rhs.name
            && lhs.core == rhs.core
            && lhs.features == rhs.features
            && lhs.views == rhs.views
            && lhs.buildType == rhs.buildType
            //TODO: add platform
    }
}
