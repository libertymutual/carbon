//
//  BiometricModuleTests.swift
//  AppPlatformTests
//
//  Created by McKim, Mark (LIT) on 13/11/2017.
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
@testable import AppPlatform

class BiometricModuleTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testIsSupporte() {
        let biometric = BiometricModule()
        XCTAssert(biometric.isSupported() == false)
    }
    func testGetBiometricType() {
        let biometric = BiometricModule()
        XCTAssert(biometric.getBiometricType() == "none")
    }
    // Has Credentials, Get Credentials, Save Credentials & Delete Credentials cannot be easily tested as they
    // require interaction with User Defaults
}
