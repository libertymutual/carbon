//
//  FeatureConfigTests.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

class FeatureConfigTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitFailures() {
        // Wrong config
        XCTAssertThrowsError(try FeatureConfig(attributes: ["fake": "config"])) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("Error not found")
            }

            XCTAssertEqual(value, "name")
        }

        // Just name specified
        XCTAssertThrowsError(try FeatureConfig(attributes: ["name": "Test"])) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("Error not found")
            }

            XCTAssertEqual(value, "viewConfig")
        }

        // Wrong viewConfig specified
        XCTAssertThrowsError(try FeatureConfig(attributes: ["name": "Test", "viewConfig": ["name": "bla"]])) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("Error not found")
            }
            // missing config
            XCTAssertEqual(value, "config")
        }
    }

    func testInit() {

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
            XCTAssertEqual(featureConfig.name, "Test")
            XCTAssert(featureConfig.viewConfig != nil)
            XCTAssertEqual(featureConfig.viewConfig?.name, "ReactNative")

            XCTAssert(featureConfig == featureConfig)

        } else {
            XCTFail("FeatureConfig not initialized")
        }
    }

    func testEquatable() {
        let attributes = [
            "name": "Test",
            "config": ["theme": "light"],
            "viewConfig": [
                "name": "ReactNative",
                "config": [
                    "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
                    "moduleName": "HelloWorld",
                    "initialProperties": ["test", "initialProp"],
                    "launchOptions": ["launch", ["one": 1]]
                ]
            ]
            ] as [String: Any]

        let attributes2 = [
            "name": "Test2",
            "config": ["theme2": "light"],
            "viewConfig": [
                "name": "ReactNative",
                "config": [
                    "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
                    "moduleName": "HelloWorld",
                    "initialProperties": ["test", "initialProp"],
                    "launchOptions": ["launch", ["one": 1]]
                ]
            ]
            ] as [String: Any]

        let fc1 = try? FeatureConfig(attributes: attributes)
        let fc2 = try? FeatureConfig(attributes: attributes)
        let fc3 = try? FeatureConfig(attributes: attributes2)
        XCTAssert(fc1 == fc2)
        XCTAssert(fc1 != fc3)
    }

}
