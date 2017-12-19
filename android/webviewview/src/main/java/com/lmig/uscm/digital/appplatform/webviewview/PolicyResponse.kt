package com.lmig.uscm.digital.appplatform.webviewview

/**
 * Defines all possible cases for navigation
 */
enum class PolicyResponse {
    // Website loaded in the app
    WEBSITE,
    // Embedded/local HTML
    APP,
    // Triggers going back to the app home screen
    GO_TO_APP_HOME,
    // When eService is in maintenance mode
    MAINTENANCE,
    // Open a remote webpage without leaving the app, implemented using a modal web view
    GO_TO_EXTERNAL_URL_IN_MODAL,
    // Leave the app and open a remote webpage in the browser
    GO_TO_EXTERNAL_URL_IN_BROWSER,
    // Stay in the app and open URL in the same view (special case for allowing load of tracking pixel,
    // Nest etc. in the same view)
    GO_TO_EXTERNAL_URL_IN_APP,
    // Allows intent
    ALLOW_INTENT,
    // Blocks intent
    BLOCK_INTENT,
    // Open App Store URL
    INTENT_APP_STORE,
    // Log out from eService
    LOG_OUT,
    // Error handling
    ERROR,
    // Closes modal view
    CLOSE_MODAL
}