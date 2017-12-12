//
//  ReactNativeViewTests.swift
//  ReactNativeViewTests
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

class ReactNativeViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        if let rnv = try? ReactNativeView(config: ViewConfig(attributes: [
            "name": "ReactNative",
            "config": [
                "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
                "moduleName": "HelloWorld",
                "initialProperties": [AnyHashable("test"): 123],
                "launchOptions": [AnyHashable("something"): "myConfig"]
                ] as [String: Any]
            ]
        )) {
            XCTAssertNotNil(rnv.viewController)
        } else {
            XCTFail("ReactNativeView not initialized")
        }

    }

}
