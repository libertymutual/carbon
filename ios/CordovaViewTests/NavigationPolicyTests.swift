//
//  NavigationPolicyTests.swift
//  AppPlatformTests
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

class TestNavigationPolicy: NavigationPolicy {
    required init() {}
}

class NavigationPolicyTests: XCTestCase {
    var navPolicy: TestNavigationPolicy?

    override func setUp() {
        super.setUp()
        self.navPolicy = TestNavigationPolicy()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetPolicyHTTP() {
        let url = URL(string: "http://www.example.org")!
        XCTAssertEqual(self.navPolicy!.getPolicy(url: url), PolicyResponse.app)
    }

    func testGetPolicyHTTPS() {
        let url = URL(string: "https://www.example.org")!
        XCTAssertEqual(self.navPolicy!.getPolicy(url: url), PolicyResponse.app)
    }

    func testGetPolicyAppStore() {
        let url = URL(string: "itms-apps://xyz")!
        XCTAssertEqual(self.navPolicy!.getPolicy(url: url), PolicyResponse.intentAppStore)
    }

    func testGetPolicyFile() {
        let url = URL(string: "file://xyz")!
        XCTAssertEqual(self.navPolicy!.getPolicy(url: url), PolicyResponse.app)
    }

    func testGetPolicyIntent() {
        let url = URL(string: "my-intent://xyz")!
        XCTAssertEqual(self.navPolicy!.getPolicy(url: url), PolicyResponse.allowIntent)
    }

    func testGetPolicyInvalidScheme() {
        let url = URL(string: "invalid")!
        XCTAssertEqual(self.navPolicy!.getPolicy(url: url), PolicyResponse.app)
    }

    func testHandleIntentInvalidScheme() {
        let url = URL(string: "invalid")!
        XCTAssertEqual(self.navPolicy!.handleIntent(url: url), PolicyResponse.app)
    }

    func testAllowNavigationForPolicy() {
        let url = URL(string: "https://www.example.org")!
        XCTAssertTrue(self.navPolicy!.allowNavigationForPolicy(policy: PolicyResponse.app, andUrl: url))
    }
}
