//
//  AppManagerTests.swift
//  AppManagerTests
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
@testable import AppPlatform

class AppManagerTests: XCTestCase {
    var manager: FeatureManager!
    var appConfig: AppConfig!
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

    override func setUp() {
        super.setUp()

        if let featureConfig = try? FeatureConfig(attributes: self.attributes) {
            let feature = TestFeature(config: featureConfig)

            self.manager = FeatureManager(feature: feature)
            if let conf = try? AppConfig(fileName: "testApp11", bundle: Bundle(for: type(of: self)),
                                         appBuildType: "release") {
                self.appConfig = conf
            } else {
                XCTFail("AppConfig not set")
            }
        } else {
            XCTFail("FeatureConfig is not correct")
        }

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        if self.appConfig == nil || self.manager == nil {
            XCTFail("Setup is not correct")
        } else {

            let appManager = AppManager(featureManager: self.manager, config: self.appConfig)
            XCTAssert(appManager.config == self.appConfig as AppConfig)

            appManager.featureManager.defaultFeature = "fake"

            XCTAssertThrowsError(try appManager.navigationManager.startDefaultFeature()) { error in
                guard case ValidationError.invalid(let value) = error else {
                    return XCTFail("Start feature failed")
                }

                XCTAssertEqual(value, "No default feature specified")
            }
        }
    }

    func testInitPerformance() {
        if self.appConfig == nil || self.manager == nil {
            XCTFail("Setup is not correct")
        }

        self.measure {
            for _ in 1...1000 {
                if let featureConfig = try? FeatureConfig(attributes: self.attributes) {
                    let feature = TestFeature(config: featureConfig)
                    let manager = FeatureManager(feature: feature)
                    if let conf = try? AppConfig(fileName: "testApp11", bundle: Bundle(for: type(of: self)),
                                                 appBuildType: "release") {
                        _ = AppManager(featureManager: manager, config: conf)
                    } else {
                        XCTFail("AppConfig not set")
                    }
                } else {
                    XCTFail("FeatureConfig is not correct")
                }
            }
        }
    }
}
