//
//  PolicyResonse.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

/// Defines all possible cases for navigation
public enum PolicyResponse: String {
    // Website related URLs
    case website = "website"
    /// Embedded/local HTML
    case app = "app"
    /// Triggers going back to the app home screen
    case goToAppHome = "goToAppHome"
    /// When the app is in maintenance mode
    case maintenance = "maintenance"
    /// Open a remote webpage without leaving the app, implemented using a modal web view
    case goToExternalUrlInModal = "goToExternalUrlInModal"
    /// Leave the app and open a remote webpage in the browser
    case goToExternalUrlInBrowser = "goToExternalUrlInBrowser"
    /// Stay in the app and open URL in the same view (special case for allowing load of tracking pixel,
    /// Nest etc. in the same view)
    case goToExternalUrlInApp = "goToExternalUrlInApp"
    /// Allows intent
    case allowIntent = "allowIntent"
    /// Blocks intent
    case blockIntent = "blockIntent"
    /// Open App Store URL
    case intentAppStore = "intentAppStore"
    /// Log out
    case logOut = "logOut"
    /// Error handling
    case error = "error"
    /// Closes modal view
    case closeModal = "close"
}
