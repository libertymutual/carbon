//
//  NavigationPolicy.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
import XCGLogger

/// Presents simple enum that covers different URL schemes
public enum UrlScheme: String {
    case HTTP = "http"
    case HTTPS = "https"
}

public protocol NavigationPolicy: class {
    init()

    func getPolicy(url: URL) -> PolicyResponse
    func handleIntent(url: URL) -> PolicyResponse
    func handleHttp(url: URL) -> PolicyResponse
    func allowNavigationForPolicy(policy: PolicyResponse, andUrl url: URL) -> Bool
}

/// Defualt implementation
extension NavigationPolicy {
    /**
     Depending on the URL scheme different methods will be triggered to determine proper policy response
     
     - Parameter url: `NSURL` object we want to check
     - Returns: `PolicyResponse` object that is later used for determining the action for URL
     */
    public func getPolicy(url: URL) -> PolicyResponse {
        if let schemeString = url.scheme {
            guard let scheme = UrlScheme(rawValue: schemeString) else {
                return self.handleIntent(url: url)
            }
            switch scheme {
            case UrlScheme.HTTP:
                return self.handleHttp(url: url)
            // HTTPS URLs are treated the same way as HTTP
            case UrlScheme.HTTPS:
                return self.handleHttp(url: url)
            }
        }
        return handleHttp(url: url)
    }

    /**
     Determines what to do with different intents like `itms-apps`, `mail` etc.
     Currently only basic coverage. Will be extended later
     
     - Parameter url: `NSURL` that has a scheme that is different than classic HTTP/HTTPS
     - Returns: Intent related `PolicyResponse`
     */
    public func handleIntent(url: URL) -> PolicyResponse {
        guard let scheme = url.scheme else {
            return .app
        }

        switch scheme {
        case "itms-apps":
            return .intentAppStore
        case "about", "gap", "file":
            return .app
        default:
            // @todo - whitelist check
            return .allowIntent
        }
    }

    public func handleHttp(url: URL) -> PolicyResponse {
        return .app
    }

    public func allowNavigationForPolicy(policy: PolicyResponse, andUrl url: URL) -> Bool {
        return true
    }
}
