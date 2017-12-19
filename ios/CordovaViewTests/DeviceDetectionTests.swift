//
//  DeviceDetectionTests.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

class DeviceDetectionTests: XCTestCase {
    func testDeviceType() {
        let currentDeviceType = DeviceDetection.getDeviceType()
        var expectedDeviceType = ""
        switch UI_USER_INTERFACE_IDIOM() {
        case .pad:
            expectedDeviceType = "tablet"
            break
        case .phone:
            expectedDeviceType = "smartphone"
            break
        default:
            XCTFail("Device type not detected")
        }

        XCTAssertEqual(currentDeviceType, expectedDeviceType, "Failed to determine current device type")

        // Take 2 - test caching
        let currentDeviceType2 = DeviceDetection.getDeviceType()
        XCTAssertEqual(currentDeviceType2, expectedDeviceType, "Failed to determine current device type")
    }
}
