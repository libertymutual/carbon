//
//  LMIGWebViewEngine.swift
//  Liberty Mutual WKWebView plugin for Cordova
//
//  Copyright © 2016 Liberty Mutual. All rights reserved.
//

import WebKit
import Foundation
import Cordova

let CDV_BRIDGE_NAME = "cordova"
let CDV_WKWEBVIEW_FILE_URL_LOAD_SELECTOR = "loadFileURL:allowingReadAccessToURL:"

@objc(LMIGWebViewEngine)

class LMIGWebViewEngine : CDVPlugin, CDVWebViewEngineProtocol, WKScriptMessageHandler, WKNavigationDelegate, LMIGWebEngine {

    fileprivate final var frame : CGRect
    fileprivate var uiDelegate:WKUIDelegate!
    fileprivate var _engineWebView:UIView!

    // CDVWebViewEngineProtocol required objc object to conform the protocol
    @objc var engineWebView:UIView! {
        get { return _engineWebView }
        set { _engineWebView = newValue }
    }

    // init - sets configuration and inits WKWebView
    required init(frame: CGRect) {
        self.frame = frame
        super.init()
        if NSClassFromString("WKWebView") == nil {
            return
        }

        // @todo - set CFBundleDisplayName
        self.uiDelegate = LMIGWebViewUIDelegate(
            title: String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName"))
        )

    }

    // Initializes the plugin and updates the settings
    override func pluginInitialize() {



        NSLog("[pluginInitialize]")
        // viewController would be available now. we attempt to set all possible delegates to it, by default

        var wkWebView : WKWebView;

        let configuration: WKWebViewConfiguration = buildConfiguration()

        // Set the navigation delegate and ui delegates from the view controller
        if let wvEngineController = self.viewController as? LMIGWebViewEngineController {
            wvEngineController.wvEngine = self

            wkWebView = WKWebView(frame: frame, configuration: configuration)
            wkWebView.uiDelegate = self.uiDelegate
            NSLog("Using WKWebView - LMIG edition")

            if let navigationDelegate = wvEngineController.getWebViewNavigationDelegate() {
                wkWebView.navigationDelegate = navigationDelegate
                NSLog("Using \(type(of: navigationDelegate)) as navigation delegate")
            }

            if let uiDelegate = wvEngineController.getUiDelegate() {
                wkWebView.uiDelegate = uiDelegate
                NSLog("Using \(type(of: uiDelegate)) as UI delegate")
            }
            else if let internalUiDelegate = self as? WKUIDelegate{
                wkWebView.uiDelegate = internalUiDelegate
                NSLog("Using \(type(of: internalUiDelegate)) as UI delegate")
            }

            self.engineWebView = wkWebView


        }
            // If the vc doesn't implement the controller protocol, make sure we still set ourselves as the ui delegate
        else if let internalUiDelegate = self as? WKUIDelegate {
            wkWebView = WKWebView(frame: self.frame)
            wkWebView.uiDelegate = internalUiDelegate
            NSLog("Using \(type(of: uiDelegate)) as UI delegate")

            self.engineWebView = wkWebView

        }

        self.updateSettings(self.commandDelegate.settings! as NSDictionary)



        // check if content thread has died on resume
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main, using: onAppWillEnterForeground)
    }

    // Method will be triggered when event UIApplicationWillEnterForegroundNotification has been called
    func onAppWillEnterForeground(_ notification: Notification) {
        _ = self.reloadIfRequired()
    }

    // Reloads webview if thread has died (title of the view does not exist)
    func reloadIfRequired() -> Bool {
        let wkWebView: WKWebView = (engineWebView as! WKWebView)
        let title: String = wkWebView.title!
        let reload: Bool = (title == "")
        #if DEBUG
            print("\("LMIGWebViewEngine reloadIfRequired")")
            print("LMIGWebViewEngine reloadIfRequired WKWebView.title: \(title)")
            print("LMIGWebViewEngine reloadIfRequired reload: \(reload)")
        #endif
        if reload {
            #if DEBUG
                print("\("CDVWKWebViewEngine reloading!")")
            #endif
            wkWebView.reload()
        }
        return reload
    }

    // Loads request in WKWebView
    @objc(loadRequest:) func load(_ request: URLRequest) -> Any! {
        NSLog("[loadRequest]")
        let wkWebView = engineWebView as! WKWebView

        return wkWebView.load(request)!
    }

    // Evaluates javascript and triggers completion handler when execution is done
    func evaluateJavaScript(_ javaScriptString: String!, completionHandler: ((Any?, Error?) -> Void)!) -> Void {
        let completion = completionHandler

        (engineWebView as! WKWebView).evaluateJavaScript(javaScriptString, completionHandler: {
            (result: Any?, error: Error?) -> Void in
            if completion != nil {
                completion!(result, error)
            }
        })
    }

    // Enables loading of HTML string to web view
    func loadHTMLString(_ string: String!, baseURL:URL!) -> Any! {
        NSLog("[loadHTMLString]")
        return (engineWebView as! WKWebView).loadHTMLString(string, baseURL:baseURL) as WKNavigation?
    }

    // Returns URL
    func url() -> URL! {
        return (engineWebView as! WKWebView).url
    }

    // Required by CDVWebViewEngineProtocol
    func canLoad(_ request:URLRequest!) -> Bool {
        NSLog("[canLoadRequest]")
        return true
    }

    // Updates settings for webview
    func updateSettings(_ settings:NSDictionary!) {
        NSLog("[updateSettings]")
        let wkWebView = _engineWebView as! WKWebView

        wkWebView.configuration.preferences.minimumFontSize = settings.cordovaFloatSetting(forKey: "MinimumFontSize", defaultValue:0.0)
        wkWebView.configuration.allowsInlineMediaPlayback = settings.cordovaBoolSetting(forKey: "AllowInlineMediaPlayback", defaultValue:false)
        wkWebView.configuration.suppressesIncrementalRendering = settings.cordovaBoolSetting(forKey: "SuppressesIncrementalRendering", defaultValue:false)
        if #available(iOS 9.0, *) {
            wkWebView.configuration.requiresUserActionForMediaPlayback = settings.cordovaBoolSetting(forKey: "MediaPlaybackRequiresUserAction", defaultValue:true)
            wkWebView.configuration.allowsAirPlayForMediaPlayback = settings.cordovaBoolSetting(forKey: "MediaPlaybackAllowsAirPlay", defaultValue:true)
        } else {
            wkWebView.configuration.mediaPlaybackRequiresUserAction = settings.cordovaBoolSetting(forKey: "MediaPlaybackRequiresUserAction", defaultValue:true)
            wkWebView.configuration.mediaPlaybackAllowsAirPlay = settings.cordovaBoolSetting(forKey: "MediaPlaybackAllowsAirPlay", defaultValue:true)
        }

        // By default, DisallowOverscroll is false (thus bounce is allowed)
        let bounceAllowed:Bool = !(settings.cordovaBoolSetting(forKey: "DisallowOverscroll", defaultValue:false))

        // prevent webView from bouncing
        if !bounceAllowed {
            if wkWebView.responds(to: #selector(getter: UIView.scrollView)) {
                wkWebView.scrollView.bounces = false
            } else {
                for subview in wkWebView.subviews {
                    if type(of: subview).isSubclass(of: UIScrollView.self) {
                        (subview as! UIScrollView).bounces = false
                    }
                }
            }
        }
    }
    // Updates configuration with the new information
    func update(withInfo info: [AnyHashable : Any]!) {
        NSLog("[updateWithInfo]")
        let infoDictionary = info! as NSDictionary
        let scriptMessageHandlers = infoDictionary[kCDVWebViewEngineScriptMessageHandlers] as! Dictionary<NSObject, Any>
        let settings = infoDictionary[kCDVWebViewEngineWebViewPreferences] as! NSDictionary
        let navigationDelegate = infoDictionary[kCDVWebViewEngineWKNavigationDelegate] as! WKNavigationDelegate
        let uiDelegate = infoDictionary[kCDVWebViewEngineWKUIDelegate] as! WKUIDelegate

        let wkWebView = _engineWebView as! WKWebView

        if (scriptMessageHandlers.count > 0) {
            let allKeys = Array(scriptMessageHandlers.keys)

            for key in allKeys {
                let object = scriptMessageHandlers[key] as! WKScriptMessageHandler
                if object.conforms(to: WKScriptMessageHandler.self) {
                    wkWebView.configuration.userContentController.add(object, name: key as! String)
                }
            }
        }

        if navigationDelegate.conforms(to: WKNavigationDelegate.self) {
            wkWebView.navigationDelegate = navigationDelegate
        }

        if uiDelegate.conforms(to: WKUIDelegate.self) {
            wkWebView.uiDelegate = uiDelegate
        }

        self.updateSettings(settings)
    }

    // This forwards the methods that are in the header that are not implemented here.
    // Both WKWebView and UIWebView implement the below:
    //     loadHTMLString:baseURL:
    //     loadRequest:
    override func forwardingTarget(for aSelector: Selector) -> Any? {
        return _engineWebView
    }

    // Invoked when a script message is received from a webpage.
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name != CDV_BRIDGE_NAME {
            return
        }
        let vc: CDVViewController = (self.viewController as! CDVViewController)
        let jsonEntry = message.body

        // NSString:callbackId, NSString:service, NSString:action, NSArray:args
        let command: CDVInvokedUrlCommand = CDVInvokedUrlCommand(fromJson: jsonEntry as! [Any])
        if !vc.commandQueue.execute(command) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonEntry, options: [])
                let commandJson:String! = String(data: jsonData, encoding: String.Encoding.utf8)

                let maxLogLength: Int = 1024
                let commandString: String
                if (commandJson!.count > maxLogLength) {
                    let index: String.Index = commandJson.index(commandJson.startIndex, offsetBy: maxLogLength)
                    commandString = "\(String(commandJson[..<index]))[...]"
                }
                else {
                    commandString = commandJson!
                }
                NSLog("FAILED pluginJSON = %@", commandString);
            }
            catch {
                print(error)
            }
        }
    }

    /**
     Retrieve the process pool from our LMIGWebViewCacheBearer
     */

    internal func getProcessPool(_ wvEngineController:LMIGWebViewEngineController) -> WKProcessPool?{
        if let cacheBearer = wvEngineController as? LMIGWebViewCacheBearer {
            NSLog("LMIGWebView is using a shared cache");
            if let processPool = cacheBearer.getProcessPool(){
                return processPool
            }
        }
        return nil
    }

    /**

     Build the configuration for our WKWebView

     */
    internal func buildConfiguration() -> WKWebViewConfiguration{
        let configuration: WKWebViewConfiguration = WKWebViewConfiguration()

        let userContentController: WKUserContentController = WKUserContentController()
        userContentController.add(self, name: CDV_BRIDGE_NAME)

        configuration.userContentController = userContentController



        // Set the navigation delegate and ui delegates from the view controller
        if let wvEngineController = self.viewController as? LMIGWebViewEngineController {
            wvEngineController.wvEngine = self

            // This enables shared caching
            if let processPool = getProcessPool(wvEngineController){
                configuration.processPool = processPool
            }

            if let scriptHandler = wvEngineController.getMessageHandler() {
                configuration.userContentController.add(scriptHandler, name: "cordova")
                NSLog("Added \(type(of: scriptHandler)) as script handler")
            }
        }
        return configuration
    }

}
