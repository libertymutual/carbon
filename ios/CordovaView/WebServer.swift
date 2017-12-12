//
//  WebServer.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

// Wrapper class for GCDWebServer
// - to *gain* higher granularity control over the server
// -

//import Foundation
//import GCDWebServer
//
/////
///// Wrapper Class for the @GCDWebServer
/////
/////
///// **Motivations**:
//
///// - Gain higher fidelity control over the local web server
///// - Centralize and Harden our API calls to GCDWebServer
//
//final public class WebServer {
//
//    /// Our wrapped instance of GCDWebServer
//    var webServer: GCDWebServer?
//
//    public init() {
//        webServer = GCDWebServer()
//    }
//
//    /// Map a URL to a local HTML file
//    /// In a typical case, we want to map the root '/' to our equivalent 'index.html' page
//    public func addGETHandlerForBasePath(basePath: String!,
//                                         directoryPath: String!,
//                                         indexFilename: String!,
//                                         cacheAge: UInt,
//                                         allowRangeRequests: Bool) {
//
//        if(webServer == nil) {
//            return
//        }
//
//        webServer!.addGETHandler(forBasePath: basePath,
//                                 directoryPath: directoryPath,
//                                 indexFilename: indexFilename,
//                                 cacheAge:cacheAge,
//                                 allowRangeRequests: allowRangeRequests)
//    }
//
//    /// Start server at specified port
//    ///
//    /// - returns: true if server launched successfully
//    public func startWithPort(port: UInt, bonjourName: String!) -> Bool {
//        return webServer!.start(withPort: port, bonjourName: bonjourName)
//    }
//
//    /// Is the Web Server running at specified port?
//    ///
//    /// - returns: true if server is currently running
//    public func isRunning() -> Bool {
//        return webServer!.isRunning
//    }
//
//}
