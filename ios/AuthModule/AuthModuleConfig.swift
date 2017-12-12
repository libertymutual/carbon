//
//  AuthConfig.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation

/// Config for the authentication module
public struct AuthModuleConfig {
    public var name: String = "auth_module"
    public var authURL: String = ""
    public var clientId: String = ""
    public var clientSecret: String = ""
    public var validatorId: String = ""

    public init(name: String,
                authURL: String,
                clientId: String,
                clientSecret: String,
                validatorId: String) {

        self.name = name
        self.authURL = authURL
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.validatorId = validatorId
    }

    /**
     Initialization method for auth module config

     - parameter attributes: Takes `[String: Any]` and sets values to the instance
     - returns: `void` or throws `ValidationError` in case of problems
     */
    public init(attributes: [String: Any]) throws {
        guard let authURL = attributes["authURL"] as? String else {
            throw ValidationError.missing("authURL")
        }

        guard let clientId = attributes["clientId"] as? String else {
            throw ValidationError.missing("clientId")
        }

        guard let clientSecret = attributes["clientSecret"] as? String else {
            throw ValidationError.missing("clientSecret")
        }

        guard let validatorId = attributes["validatorId"] as? String else {
            throw ValidationError.missing("validatorId")
        }

        self.authURL = authURL
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.validatorId = validatorId
    }
    /**
     Obtain a dictionary from a file in order to create an AuthConfig

     - parameter fileName: the filename for the JSON containing the configs
     - parameter key: the name of the config to load from the auth file

     */
    public static func getConfigDict(inFile fileName: String,
                                     matchingKey key: String,
                                     inBundle bundle: Bundle) throws -> [String: Any]? {
        guard let file = bundle.path(forResource: fileName, ofType: "json") else {
            throw ValidationError.invalid("Unable to find file \(fileName)")
        }

        let url = URL(fileURLWithPath: file)
        let jsonData = try Data(contentsOf: url)

        guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: AnyObject]] else {
            throw ValidationError.invalid("\(fileName) is not valid json")
        }

        for configJson in json {
            guard let name = configJson["name"] as? String else {
                throw ValidationError.missing("name field from auth config in json")
            }

            guard name == key else {
                continue
            }
            return configJson
        }
        return nil
    }
}

/// Compares two `AuthModuleConfig` objects
extension AuthModuleConfig: Equatable {
    public static func == (lhs: AuthModuleConfig, rhs: AuthModuleConfig) -> Bool {
        return lhs.authURL == rhs.authURL && lhs.clientId == rhs.clientId
            && lhs.clientSecret == rhs.clientSecret && lhs.validatorId == rhs.validatorId
    }
}
