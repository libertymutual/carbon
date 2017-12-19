//
//  CordovaFeatureTests.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform
import WebKit

/// Test feature with Cordova view
class TCordovaFeature: CordovaFeature, Feature {
    var name: String = "TestCordova"
    var config: FeatureConfig?
    var view: View?

    // Init is required to conform protocol
    required init() {}

    /**
     Initialization method for setting feature config a view. Implements RN view
     
     - returns: throws `ValidationError` if view not loaded, `void` otherwise
     */
    func setup() throws {
        // use default extension implementation
        try self.setupCordova()
    }

}

class CordovaFeatureTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        if let conf = try? FeatureConfig(attributes: [
            "name": "TestCordova",
            "config": ["theme": "light"],
            "viewConfig": [
                "name": "Cordova",
                "config": [
                    "url": "http://www.google.com/"
                ]
            ]
            ]) {
            let feature = TCordovaFeature(config: conf)
            XCTAssert(feature.config == conf)

            do {
                try feature.setup()
                XCTAssert(feature.view is CordovaView)

                feature.config?.viewConfig = nil
                XCTAssertThrowsError(try feature.setupCordova()) { error in
                    guard case ValidationError.invalid(let value) = error else {
                        return XCTFail("Error not found")
                    }
                    XCTAssertEqual(value, "View not loaded")
                }
            } catch {
                XCTFail("Setup failed")
            }

        } else {
            XCTFail("FeatureConfig not initialized")
        }
    }

    func testNavigate() {
        if let conf = try? FeatureConfig(attributes: [
            "name": "TestCordova",
            "config": ["theme": "light"],
            "viewConfig": [
                "name": "Cordova",
                "config": [
                    "url": "http://www.google.com/"
                ]
            ]
            ]) {
            let feature = TCordovaFeature(config: conf)
            XCTAssert(feature.config == conf)

            do {
                try feature.setup()
                if var viewConfig = feature.config?.viewConfig?.config as? CordovaViewConfig {
                    let url = URL(string: "https://www.libertymutual.com/")!
                    viewConfig.url = url
                    feature.navigate()
                    // Needs UI to be tested
//                    if let cdvViewController = feature.view?.viewController as? CordovaViewController,
//                       let webView = cdvViewController.webView as? WKWebView {
//                        XCTAssertEqual(webView.url, url)
//                    } else {
//                        XCTFail("No Webview")
//                    }
                } else {
                    XCTFail("ViewConfig is not CordovaViewConfig")
                }
            } catch {
                XCTFail("Setup failed")
            }
        } else {
            XCTFail("FeatureConfig not initialized")
        }
    }
}
