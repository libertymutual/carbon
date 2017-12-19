//
//  FeatureTests.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

class TestFeature: Feature {

    /**
     Initialization method required for protocol
     */
    public required init() {}

    var name: String = "Test"
    var config: FeatureConfig?
    var view: View?

    func setup() throws {
        if let viewConfig = self.config?.viewConfig {
            self.view = ExampleView(config: viewConfig)
        } else {
            throw ValidationError.invalid("View not loaded")
        }
    }

    func navigate() {}
}

class FeatureTests: XCTestCase {

    func testInit() {
        let feature = TestFeature(config: nil)
        XCTAssertEqual(feature.name, "Test")

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
            let f2 = TestFeature(config: featureConfig)
            XCTAssertEqual(f2.config?.name, featureConfig.name)
            XCTAssertEqual(f2.config?.viewConfig?.name, featureConfig.viewConfig?.name)

        } else {
            XCTFail("config not set")
        }
    }

    func testSetup() {
        let feature = TestFeature()

        XCTAssertThrowsError(try feature.setup()) { error in
            guard case ValidationError.invalid(let value) = error else {
                return XCTFail("No failure using Feature class directly")
            }

            XCTAssertEqual(value, "View not loaded")
        }
    }

}
