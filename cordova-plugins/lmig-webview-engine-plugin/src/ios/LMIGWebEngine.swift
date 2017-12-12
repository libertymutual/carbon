//
//  LMIGWebEngine.swift
//  Pods
//
//  Created on 5/19/16.
//
//

/**
 Defines a class that can act as a controller to the LMIGWebViewEngine. This includes getting delegates for
 url filtering functionality.
 */
@objc public protocol LMIGWebEngine {
    /**
     Load the given URL in the web view
     */
    @objc(loadRequest:) func load(_ request: URLRequest) -> Any!

    /**
     Evaluate a Javascript function inside the engine
     */
    func evaluateJavaScript(_ javaScriptString: String!, completionHandler: ((Any?, Error?) -> Void)!) -> Void
}
