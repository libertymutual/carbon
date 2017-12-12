//
//  FeatureConfig.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation

/// FeatureConfig - configuration structure for features
public struct FeatureConfig {
    public var name: String
    public var viewConfig: ViewConfig?

    /**
        Initialization method for feature config

        - parameter attributes: Takes `[String: Any]` and sets values to the instance
        - returns: `void` or throws `ValidationError` in case of problems
     */
    public init(attributes: [String: Any]) throws {
        guard let name = attributes["name"] as? String else {
            throw ValidationError.missing("name")
        }

        guard let viewConfig = attributes["viewConfig"] as? [String: Any] else {
            throw ValidationError.missing("viewConfig")
        }

        self.name = name
        self.viewConfig = try ViewConfig(attributes: viewConfig)
    }
}

/// Compares two `FeatureConfig` objects
extension FeatureConfig: Equatable {
    public static func == (lhs: FeatureConfig, rhs: FeatureConfig) -> Bool {
        return lhs.name == rhs.name && lhs.viewConfig == rhs.viewConfig
    }
}
