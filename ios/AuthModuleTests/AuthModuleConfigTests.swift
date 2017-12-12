//
//  AuthModuleConfigTests.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

class AuthModuleConfigTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {

         // Valid config specified
        let attributes = ["authURL": "https://www.example.org/auth",
                          "clientId": "abc",
                          "clientSecret": "s3cr3t",
                          "validatorId": "dss"]

        if let authModuleConfig = try? AuthModuleConfig(attributes: attributes) {
            XCTAssertEqual(authModuleConfig.name, "auth_module")
            XCTAssertEqual(authModuleConfig.authURL, "https://www.example.org/auth")
            XCTAssertEqual(authModuleConfig.clientId, "abc")
            XCTAssertEqual(authModuleConfig.clientSecret, "s3cr3t")
            XCTAssertEqual(authModuleConfig.validatorId, "dss")

        } else {
            XCTFail("AuthModuleConfig not initialized")
        }

    }

    func testInitFailures() {
        // Wrong config
        XCTAssertThrowsError(try AuthModuleConfig(attributes: ["fake": "config"])) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("Error not found")
            }

            XCTAssertEqual(value, "authURL")
        }

        // Just authURL specified
        XCTAssertThrowsError(try AuthModuleConfig(attributes: ["authURL": "https://www.example.org/auth"])) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("Error not found")
            }

            XCTAssertEqual(value, "clientId")
        }

        // Wrong config specified
        let attributes3 = ["authURL": "https://www.example.org/auth", "clientId": "abc"]
        XCTAssertThrowsError(try AuthModuleConfig(attributes: attributes3)) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("Error not found")
            }
            // missing clientSecret
            XCTAssertEqual(value, "clientSecret")
        }

        // Wrong config specified
        let attributes4 = ["authURL": "https://www.example.org/auth", "clientId": "abc", "clientSecret": "s3cr3t"]
        XCTAssertThrowsError(try AuthModuleConfig(attributes: attributes4)) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("Error not found")
            }
            // missing clientSecret
            XCTAssertEqual(value, "validatorId")
        }

    }

}
