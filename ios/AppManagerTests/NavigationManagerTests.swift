//
//  NavigationManagerTests.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
@testable import AppPlatform

class NavigationManagerTests: XCTestCase {
    var feature: TestFeature?
    var manager: FeatureManager?
    var appManager: AppManager?
    var appConfig: AppConfig?

    override func setUp() {
        super.setUp()

        let attributes = [
            "name": "Test",
            "config": ["theme": "light"],
            "viewConfig": [
                "name": "ReactNative",
                "config": [
                    "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
                    "moduleName": "HelloWorld",
                    "initialProperties": nil,
                    "launchOptions": nil
                ]
            ]
            ] as [String: Any]

        if let featureConfig = try? FeatureConfig(attributes: attributes) {
            if let conf = try? AppConfig(fileName: "testApp11", bundle: Bundle(for: type(of: self)),
                                         appBuildType: "release") {
                self.appConfig = conf

                self.feature = TestFeature(config: featureConfig)
                self.manager = FeatureManager(feature: self.feature!)
                self.appManager = AppManager(featureManager: self.manager!, config: self.appConfig!)
            } else {
                XCTFail("AppConfig not set")
            }
        }

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNavigate() {

        let attributes = [
            "moduleName": "HelloWorld",
            "initialProperties": ["initial": "prop"],
            "launchOptions": ["launch": "option"]
        ] as [String : Any]
        if let reactNav = try? ReactNav(attributes: attributes) {
            let nav = Navigation(featureName: "Test", data: reactNav)
            let notification = Notification(name: .navigate, object: nav)
            if self.appManager != nil {
                self.appManager?.navigationManager.navigate(notification: notification)
                let viewConfig = self.appManager?
                                .featureManager.features[0].config?
                                .viewConfig?.config as? ReactNativeViewConfig

                XCTAssertEqual((viewConfig?.initialProperties as? [String: String])!, ["initial": "prop"])
                XCTAssertEqual((viewConfig?.launchOptions as? [String: String])!, ["launch": "option"])
                XCTAssertEqual(self.appManager?.featureManager.currentFeatureName, "Test")
            } else {
                XCTFail("Setup not initiated correctly")
            }
        } else {
            XCTFail("Setup failed")
        }

    }

    func testNatigateWrong() {
        let notification = Notification(name: .navigate, object: ["wrong": "object"])
        if self.appManager != nil {
            self.appManager?.navigationManager.navigate(notification: notification)
            let viewConfig = self.appManager?
                .featureManager.features[0].config?
                .viewConfig?.config as? ReactNativeViewConfig

            XCTAssertNil(viewConfig?.initialProperties)
            XCTAssertNil(viewConfig?.launchOptions)
            XCTAssertEqual(self.appManager?.featureManager.currentFeatureName, "Test")
        } else {
            XCTFail("Setup not initiated correctly")
        }
    }

    func testGoTo() {
        let attributes = [
            "moduleName": "HelloWorld",
            "initialProperties": ["initial": "prop"],
            "launchOptions": ["launch": "option"]
            ] as [String : Any]
        if let reactNav = try? ReactNav(attributes: attributes) {
            let nav = Navigation(featureName: "Test", data: reactNav)
            // Set expectation
            let handler = { (notification: Notification) -> Bool in
                if let navObj = notification.object as? Navigation {
                    return navObj.featureName == nav.featureName
                        && navObj.data as? ReactNav == nav.data as? ReactNav
                }
                return false
            }
            expectation(forNotification: NSNotification.Name(rawValue: "NAVIGATE"), object: nil, handler: handler)
            self.appManager?.navigationManager.goTo(nav: nav)
            waitForExpectations(timeout: 0.1, handler: nil)
        }
    }

    func testReactNavEquatable() {
        let a1 = [
            "moduleName": "HelloWorld",
            "initialProperties": [AnyHashable("test"): "123", AnyHashable("str"): "test"],
            "launchOptions": [AnyHashable("something"): "myConfig", AnyHashable("int"): "456"]
            ] as [String: Any]

        let a2 = [
            "moduleName": "HelloWorld",
            "initialProperties": [AnyHashable("test"): 2343243232432],
            "launchOptions": [AnyHashable("something"): "myConfig"]
            ] as [String: Any]

        if let r1 = try? ReactNav(attributes: a1), let r2 = try? ReactNav(attributes: a1) {
            XCTAssert(r1 == r2)
        } else {
            XCTFail("ReactNav not initiated")
        }

        if let r1 = try? ReactNav(attributes: a1), let r2 = try? ReactNav(attributes: a2) {
            XCTAssert(r1 != r2)
        } else {
            XCTFail("ReactNav not initiated")
        }
    }

    func testReactNavEquatableInt() {
        let a1 = [
            "moduleName": "HelloWorld",
            "initialProperties": [AnyHashable("test"): 123, AnyHashable("int"): 456],
            "launchOptions": [AnyHashable("something"): 777, AnyHashable("int"): 1337]
            ] as [String: Any]

        let a2 = [
            "moduleName": "HelloWorld",
            "initialProperties": [AnyHashable("test"): 2343243232432],
            "launchOptions": [AnyHashable("something"): 789]
            ] as [String: Any]

        if let r1 = try? ReactNav(attributes: a1), let r2 = try? ReactNav(attributes: a1) {
            XCTAssert(r1 == r2)
        } else {
            XCTFail("ReactNav not initiated")
        }

        if let r1 = try? ReactNav(attributes: a1), let r2 = try? ReactNav(attributes: a2) {
            XCTAssert(r1 != r2)
        } else {
            XCTFail("ReactNav not initiated")
        }
    }

    func testReactNavEquatableNil() {
        let a1 = [
            "moduleName": "HelloWorld",
            "initialProperties": [],
            "launchOptions": []
        ] as [String: Any]

        if let r1 = try? ReactNav(attributes: a1), let r2 = try? ReactNav(attributes: a1) {
            XCTAssert(r1 == r2)
        } else {
            XCTFail("ReactNav not initiated")
        }

    }

}
