//
//  Config.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation

/// Defines error types for JSON validation
public enum ValidationError: Error {
    case missing(String)
    case invalid(String)
}
