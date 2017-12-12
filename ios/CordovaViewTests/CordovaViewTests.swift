//
//  CordovaViewTests.swift
//  CordovaViewTests
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

class CordovaViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        if let cv = try? CordovaView(config: ViewConfig(attributes: [
            "name": "Cordova",
            "config": [
                "url": "http://www.google.com/"
            ]]
        )) {
            XCTAssertNotNil(cv.viewController)
        } else {
            XCTFail("CordovaView not initialized")
        }
    }

    func testInitFailuresEmptyField() {
        XCTAssertThrowsError(try CordovaView(config: ViewConfig(attributes: [
            "name": "Cordova",
            "config": []
        ]
        ))) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("No failure for missing Config")
            }
            XCTAssertEqual(value, "config")
        }

//        XCTAssertThrowsError(try ViewConfig(attributes: [
//            "name": "Cordova",
//            "config": [
//                "url": nil
//            ]] as [String: Any])) { error in
//            guard case ValidationError.missing(let value) = error else {
//                return XCTFail("No failure for missing URL")
//            }
//            XCTAssertEqual(value, "url")
//        }
    }
}
