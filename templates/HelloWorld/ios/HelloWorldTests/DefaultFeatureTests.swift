//
//  DefaultFeatureTests.swift
//  HelloWorld
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform
@testable import HelloWorld

class DefaultFeatureTests: XCTestCase {

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
            "name": "Default",
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
            let feature = DefaultFeature(config: conf)
            XCTAssert(feature.config == conf)

            do {
                try feature.setup()
                XCTAssert(feature.view is ReactNativeView)
            } catch {
                XCTFail("Setup failed")
            }

        } else {
            XCTFail("FeatureConfig not initialized")
        }

    }
}
