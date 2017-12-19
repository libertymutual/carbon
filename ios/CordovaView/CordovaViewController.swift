//
//  CordovaViewController.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Cordova
import UIKit
import lmig_webview_engine_plugin

import WebKit
// TODO: Tech Debt - Move this outside of the platform
public class CordovaViewController: CDVViewController, LMIGWebViewEngineController {
    // swiftlint:disable weak_delegate
    var navigationDelegate: NavigationDelegate?
    // swiftlint:enable weak_delegate
    var viewConfig: CordovaViewConfig?

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }

    public init(cordovaViewConfig: CordovaViewConfig) {
        self.viewConfig = cordovaViewConfig
        super.init(nibName: nil, bundle: nil)
    }

    public var wvEngine: LMIGWebEngine? {
        didSet {
            navigationDelegate?.webEngine = wvEngine
        }
    }

    public func setNavigationDelegate(navigationPolicy: NavigationPolicy) {
        self.navigationDelegate = NavigationDelegate(navigationPolicy: navigationPolicy)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        if let userAgent = self.getCustomUserAgent() {
            self.setUserAgent(userAgent: userAgent)
        }
    }

    public func loadURL(url: URL) {
        let urlRequest = URLRequest(url: url)
        _  = self.wvEngine!.load(urlRequest)
    }

    func getCustomUserAgent() -> String? {
        let userAgent = UserDefaults.standard.string(forKey: "UserAgent")
        let dictionary = Bundle.main.infoDictionary!

        if let version = dictionary["CFBundleShortVersionString"] as? String {
            // TODO: Set a string as an app setting
            return userAgent?.appendingFormat(" LMapp/%@", version)
        }
        return nil
    }

    /*
     By overriding this method and setting return value to true app layout will autorotate at app launch
     */
    override public func shouldAutorotate() -> Bool {
        return true
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func setUserAgent(userAgent: String) {
        // swiftlint:disable force_cast
        (self.webView as! WKWebView).customUserAgent = userAgent
        // swiftlint:enable force_cast
    }

    // MARK: - LMIGWebViewEngineController Protocol Methods

    /**
     Get the WKNavigationDelegate for the web view. If a delegate is 
     not provided, the underlying WKWebview will not delegate its navigation.
     
     - returns: the delegate or nil
     */
    public func getWebViewNavigationDelegate() -> WKNavigationDelegate? {
        return navigationDelegate
    }

    /**
     Get the UI delegate for the web view engine. If no delegate is specified, the engine will act as 
     the delegate to provide default behavior
     
     - returns: the delegate or nil
     */
    public func getUiDelegate() -> WKUIDelegate? {
        return nil
    }

    /**
     Get a message handler delegate for the web view engine. This can be used by 
     the implementor of the protocol to recieve messages from the web view. The
     plugin automatically handles its own cordova messages
     
     - returns: the handler or nil
     */
    public func getMessageHandler() -> WKScriptMessageHandler? {
        return nil
    }
}
