//
//  LMIGWebViewEngineDelegate.swift
//  Pods
//
//  Created on 5/18/16.
//
//

import WebKit

@objc public protocol LMIGWebViewEngineController {
    var wvEngine: LMIGWebEngine? { get set }

    /**
     Get the WKNavigationDelegate for the web view. If a delegate is not provided, the underlying WKWebview will not delegate its navigation.
     - returns: the delegate or nil
     */
    func getWebViewNavigationDelegate() -> WKNavigationDelegate?

    /**
     Get the UI delegate for the web view engine. If no delegate is specified, the engine will act as the delegate to provide default behavior

     - returns: the delegate or nil
     */
    func getUiDelegate() -> WKUIDelegate?

    /**
     Get a message handler delegate for the web view engine. This can be used by the implementor of the protocol to recieve messages from the web view. The
     plugin automatically handles its own cordova messages

     - returns: the handler or nil
     */
    func getMessageHandler() -> WKScriptMessageHandler?
}
