//
//  BiometricTests.swift
//  HelloWorldTests
//
//  Created by McKim, Mark (LIT) on 13/11/2017.
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform
import React
@testable import HelloWorld

class BiometricTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testIsSupported() {
        let biometric = Biometric()
        let resolver: RCTPromiseResolveBlock = {(results: Any?) -> Void in
            if let res = results {
                if let supported = res as? Bool {
                    XCTAssert(supported == false)
                }
            }
        }
        let rejecter: RCTPromiseRejectBlock = {(code: String?, message: String?, error: Error?) -> Void in
        }
        biometric.isSupported(resolver, rejecter: rejecter)
    }
    func testGetBiometricType() {
        let biometric = Biometric()
        let resolver: RCTPromiseResolveBlock = {(results: Any?) -> Void in
            if let res = results {
                if let stringRes = res as? String {
                    XCTAssert(stringRes == "none")
                }
            }
        }
        let rejecter: RCTPromiseRejectBlock = {(code: String?, message: String?, error: Error?) -> Void in
        }
        biometric.getBiometricType(resolver, rejecter: rejecter)
    }
    // Has Credentials, Get Credentials, Save Credentials & Delete Credentials cannot be easily tested as they
    // require interaction with User Defaults
}
