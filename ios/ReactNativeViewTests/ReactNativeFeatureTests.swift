//
//  ReactNativeFeatureTests.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

/// Test feature with RN view
class TFeature: ReactNativeFeature, Feature {
    var name: String = "Test"
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
        try self.setupReactNative()
    }

}

class ReactNativeFeatureTests: XCTestCase {

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
            "name": "Test",
            "config": ["theme": "light"],
            "viewConfig": [
                "name": "ReactNative",
                "config": [
                    "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
                    "moduleName": "Default",
                    "initialProperties": nil,
                    "launchOptions": nil
                ]
            ]
            ]) {
            let feature = TFeature(config: conf)
            XCTAssert(feature.config == conf)

            do {
                try feature.setup()
                XCTAssert(feature.view is ReactNativeView)

                feature.config?.viewConfig = nil
                XCTAssertThrowsError(try feature.setupReactNative()) { error in
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
}
