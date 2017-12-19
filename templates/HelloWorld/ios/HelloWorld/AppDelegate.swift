//
//  AppDelegate.swift
//  HelloWorld
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import UIKit
import Foundation
import AppPlatform
import React

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    public var appManager: AppManager?

    // Our local server instance
//    var webServer: WebServer?
    public var biometricModule: BiometricModule?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // Instantiate App Platform Components
        do {
//            _ = initWebServer()
            let config = try AppConfig(fileName: "app",
                                       bundle: Bundle(for: type(of: self)),
                                       appBuildType: getBuildType())
            let defaultFeature = DefaultFeature(config: nil)
            let secondFeature = SecondFeature(config: nil)
            let webFeature = WebFeature(config: nil)
            let featureManager = FeatureManager(features: [defaultFeature, secondFeature, webFeature],
                                                defaultFeature: "Default")
            self.appManager = AppManager(featureManager: featureManager, config: config)

            if let modules = self.appManager?.config.modules {
                for module in modules where module.key == "Auth" {
                    // TODO: this should be configured based on the app build or from a key in app.json
                    let configName = "DEV_A"

                    let successHandler: () -> Void = {}
                    let errorHandler: (Error) -> Void = { error in
                        print("Error configuring auth on launch: \(error.localizedDescription)")
                    }

                    AuthModule.sharedInstance.configureWithCredentials(inBundle: Bundle.main,
                                                                       configName: configName,
                                                                       successHandler: successHandler,
                                                                       errorHandler: errorHandler)
                }
                for module in modules where module.key == "Biometric" {
                    self.biometricModule = BiometricModule()
                }
            }

        } catch ValidationError.invalid(let message) {
            print("[AppConfig] Invalid: \(message)")
        } catch ValidationError.missing(let field) {
            print("[AppConfig] Missing field: \(field)")
        } catch let error as NSError {
            print("Config file is invalid! \(error.localizedDescription)")
        }

        return true
    }
    func getBuildType() -> String {
        #if BUILD_TYPE_DEBUG
            return "debug"
        #elseif BUILD_TYPE_QA
            return "qa"
        #elseif BUILD_TYPE_RELEASE
            return "release"
        #else
            return "release"
        #endif
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return RCTLinkingManager.application(application,
                                             open: url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation)
    }

    // Initializes local web server
//    func initWebServer() -> Bool {
//        webServer = WebServer()
//        let webAppPath = Bundle.main.resourcePath! + "/www"
//        webServer!.addGETHandlerForBasePath(basePath: "/",
//                                            directoryPath: webAppPath,
//                                            indexFilename: "index.html",
//                                            cacheAge:3600,
//                                            allowRangeRequests: true)
//        let success = webServer!.startWithPort(port: 1234, bonjourName: nil)
//        print("Server start : " + success.description)
//        return success
//
//    }

}
