//
//  ViewConfigTests.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

class ViewConfigTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitFailures() {
        // Wrong config
        XCTAssertThrowsError(try ViewConfig(attributes: ["fake": "config"])) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("Error not found")
            }

            XCTAssertEqual(value, "name")
        }

        // Just name specified
        XCTAssertThrowsError(try ViewConfig(attributes: ["name": "Test"])) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("Error not found")
            }

            XCTAssertEqual(value, "config")
        }

        // Non-existent viewConfig specified
        XCTAssertThrowsError(try ViewConfig(attributes: ["name": "Test", "config": ["name": "bla"]])) { error in
            guard case ValidationError.invalid(let value) = error else {
                return XCTFail("Error not found")
            }
            // missing config
            XCTAssertEqual(value, "ViewConfigName")
        }
    }

    func testInit() {

        let attributes = [
            "name": "ReactNative",
            "config": [
                "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
                "moduleName": "HelloWorld",
                "initialProperties": nil,
                "launchOptions": nil
            ]
        ] as [String: Any]

        if let viewConfig = try? ViewConfig(attributes: attributes) {
            XCTAssertEqual(viewConfig.name, "ReactNative")
            XCTAssert(viewConfig.config != nil)
            if let reactNativeViewConfig = viewConfig.config as? ReactNativeViewConfig {
                let bundleURL = URL(string: "http://localhost:8081/index.ios.bundle?platform=ios")
                XCTAssertEqual(reactNativeViewConfig.bundleURL, bundleURL)
                XCTAssertEqual(reactNativeViewConfig.moduleName, "HelloWorld")
                XCTAssert(reactNativeViewConfig.initialProperties == nil)
                XCTAssert(reactNativeViewConfig.launchOptions == nil)
            } else {
                return XCTFail("Wrong view config type")
            }

        } else {
            XCTFail("ViewConfig not initialized")
        }
    }

    func testEquatable() {

        let a1 = [
            "name": "ReactNative",
            "config": [
                "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
                "moduleName": "HelloWorld",
                "initialProperties": [AnyHashable("test"): 123],
                "launchOptions": [AnyHashable("something"): "myConfig"]
            ]
        ] as [String: Any]

        let a2 = [
            "name": "ReactNative",
            "config": [
                "bundleURL": "http://localhost:8081/different-url?platform=ios",
                "moduleName": "HelloWorld2",
                "initialProperties": [AnyHashable("test"): 123],
                "launchOptions": [AnyHashable("something"): "myConfig"]
            ]
        ] as [String: Any]

        if let viewConfig1 = try? ViewConfig(attributes: a1), let viewConfig2 = try? ViewConfig(attributes: a1) {
            XCTAssert(viewConfig1 == viewConfig2)
        } else {
            XCTFail("ViewConfig not initiated")
        }

        if let viewConfig1 = try? ViewConfig(attributes: a1), let viewConfig2 = try? ViewConfig(attributes: a2) {
            XCTAssert(viewConfig1 != viewConfig2)
        } else {
            XCTFail("ViewConfig not initiated")
        }
    }
}

class ReactNativeViewConfigTests: XCTestCase {

    func testInitFailures() {
        // Wrong config
        XCTAssertThrowsError(try ReactNativeViewConfig(attributes: ["fake": "config"])) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("Error not found")
            }

            XCTAssertEqual(value, "bundleURL")
        }

        // Just bundleURL specified
        let attr1 = ["bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios"]
        XCTAssertThrowsError(try ReactNativeViewConfig(attributes: attr1)) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("moduleName test fail")
            }

            XCTAssertEqual(value, "moduleName")
        }

        // Invalid URL specified
        let attr2 = ["bundleURL": "not an URL", "moduleName": "HelloWorld"]
        XCTAssertThrowsError(try ReactNativeViewConfig(attributes: attr2)) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail(error.localizedDescription)
            }
            // missing config
            XCTAssertEqual(value, "bundleURL")
        }

    }

    func testInit() {

        let attributes = [
            "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
            "moduleName": "HelloWorld",
            "initialProperties": [AnyHashable("test"): 123],
            "launchOptions": [AnyHashable("something"): "myConfig"]
        ] as [String: Any]

        if let reactNativeViewConfig = try? ReactNativeViewConfig(attributes: attributes) {
            let url = URL(string: "http://localhost:8081/index.ios.bundle?platform=ios")
            XCTAssertEqual(reactNativeViewConfig.bundleURL, url)
            XCTAssertEqual(reactNativeViewConfig.moduleName, "HelloWorld")

            let initialProperties = (reactNativeViewConfig.initialProperties as? [AnyHashable: Int])!
            XCTAssertEqual(initialProperties, [AnyHashable("test"): 123])
            let launchOptions = (reactNativeViewConfig.launchOptions as? [AnyHashable: String])!
            XCTAssertEqual(launchOptions, [AnyHashable("something"): "myConfig"])
        } else {
            XCTFail("ReactNativeViewConfig not initiated")
        }
    }

    func testEquatable() {
        let a1 = [
            "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
            "moduleName": "HelloWorld",
            "initialProperties": [AnyHashable("test"): "123", AnyHashable("str"): "test"],
            "launchOptions": [AnyHashable("something"): "myConfig", AnyHashable("int"): "456"]
        ] as [String: Any]

        let a2 = [
            "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
            "moduleName": "HelloWorld",
            "initialProperties": [AnyHashable("test"): 2343243232432],
            "launchOptions": [AnyHashable("something"): "myConfig"]
            ] as [String: Any]

        if let c1 = try? ReactNativeViewConfig(attributes: a1), let c2 = try? ReactNativeViewConfig(attributes: a1) {
            XCTAssert(c1 == c2)
        } else {
            XCTFail("ReactNativeViewConfig not initiated")
        }

        if let c1 = try? ReactNativeViewConfig(attributes: a1), let c2 = try? ReactNativeViewConfig(attributes: a2) {
            XCTAssert(c1 != c2)
        } else {
            XCTFail("ReactNativeViewConfig not initiated")
        }
    }

    func testEquatableInt() {
        let a1 = [
            "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
            "moduleName": "HelloWorld",
            "initialProperties": [AnyHashable("test"): 123],
            // Note: combining strings and ints doesn't work
            "launchOptions": [AnyHashable("something"): 123, AnyHashable("int"): 456]
            ] as [String: Any]

        if let c1 = try? ReactNativeViewConfig(attributes: a1), let c2 = try? ReactNativeViewConfig(attributes: a1) {
            XCTAssert(c1 == c2)
        } else {
            XCTFail("View configs setup failed")
        }
    }
}

class CordovaViewConfigTests: XCTestCase {

    func testInitFailures() {
        // Wrong config
        XCTAssertThrowsError(try CordovaViewConfig(attributes: ["fake": "config"])) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("wrong config fail")
            }

            XCTAssertEqual(value, "url")
        }

        // Invalid URL specified
        let attr2 = ["url": "not an URL"]
        XCTAssertThrowsError(try CordovaViewConfig(attributes: attr2)) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail(error.localizedDescription)
            }
            // missing config
            XCTAssertEqual(value, "url")
        }

    }

    func testInit() {

        let attributes = [
            "url": "http://www.google.com/"
            ] as [String: String]

        if let cordovaViewConfig = try? CordovaViewConfig(attributes: attributes) {
            let url = URL(string: "http://www.google.com/")
            XCTAssertEqual(cordovaViewConfig.url, url)
        } else {
            XCTFail("Not a CordovaViewConfig")
        }
    }

    func testEquatable() {
        let a1 = [
            "url": "http://www.google.com/"
            ] as [String: String]

        let a2 = [
            "url": "http://www.example.org/"
            ] as [String: String]

        if let c1 = try? CordovaViewConfig(attributes: a1), let c2 = try? CordovaViewConfig(attributes: a1) {
            XCTAssert(c1 == c2)
        } else {
            XCTFail("View configs setup failed")
        }

        if let c1 = try? CordovaViewConfig(attributes: a1), let c2 = try? CordovaViewConfig(attributes: a2) {
            XCTAssert(c1 != c2)
        } else {
            XCTFail("View configs setup failed")
        }
    }
}
