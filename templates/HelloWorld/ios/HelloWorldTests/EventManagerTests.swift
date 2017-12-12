//
//  EventManagerTests.swift
//  HelloWorld
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform
import React
@testable import HelloWorld

class EventManagerTests: XCTestCase {
    class MockEventManager: EventManager {
        var callNavHasBeenCalled = false
        override func callNav(nav: Navigation) {
            callNavHasBeenCalled = true
        }
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNavigateFromReactNative() {
        let eventManager = MockEventManager()
        let text = "{\"moduleName\":\"SecondModule\",\"initialProperties\":{\"hello\":\"world\"}}"
        if let data = text.data(using: .utf8) {
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                eventManager.navigateFromReactNative("Second", object: jsonObj!)
                XCTAssert(eventManager.callNavHasBeenCalled == true)
            } catch {
                XCTFail("navigateFromReactNative failed")
            }
        }
    }
    func testGetBuildType() {
        let eventManager = EventManager()
        let resolver: RCTPromiseResolveBlock = {(results: Any?) -> Void in
            if let res = results {
                if let stringRes = res as? String {
                    XCTAssert(stringRes == "qa")
                }
            }
        }
        let rejecter: RCTPromiseRejectBlock = {(code: String?, message: String?, error: Error?) -> Void in
        }
        eventManager.getBuildType(resolver, rejecter: rejecter)
    }
}
