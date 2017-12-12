//
//  AppConfigTests.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

class AppConfigTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitFailuresJSON() {
        // Wrong file
        XCTAssertThrowsError(try AppConfig(fileName: "fake", bundle: Bundle(for: type(of: self)),
                                           appBuildType: "release")) { error in
            guard case ValidationError.invalid(let value) = error else {
                return XCTFail("No failure for wrong file")
            }

            XCTAssertEqual(value, "Wrong file")
        }

        // Mallformed JSON
        XCTAssertThrowsError(try AppConfig(fileName: "testApp1", bundle: Bundle(for: type(of: self)),
                                           appBuildType: "release")) { error in
            guard case ValidationError.invalid(let value) = error else {
                return XCTFail("No failure for mallformed JSON")
            }

            XCTAssertEqual(value, "JSON not parsed")
        }

        // Empty JSON
        XCTAssertThrowsError(try AppConfig(fileName: "testApp2", bundle: Bundle(for: type(of: self)),
                                           appBuildType: "release")) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("No failure for empty JSON")
            }

            XCTAssertEqual(value, "name")
        }
    }

    func testInitFailuresEmptyField() {

        // Empty views, features, platforms, modules
        XCTAssertThrowsError(try AppConfig(fileName: "testApp3", bundle: Bundle(for: type(of: self)),
                                           appBuildType: "release")) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("No failure for empty views")
            }

            XCTAssertEqual(value, "modules")
        }

        // No core
        XCTAssertThrowsError(try AppConfig(fileName: "testApp5", bundle: Bundle(for: type(of: self)),
                                           appBuildType: "release")) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("No failure for missing core")
            }

            XCTAssertEqual(value, "core")
        }

        // No views
        XCTAssertThrowsError(try AppConfig(fileName: "testApp6", bundle: Bundle(for: type(of: self)),
                                           appBuildType: "release")) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("No failure for missing views")
            }

            XCTAssertEqual(value, "views")
        }

        // No features
        XCTAssertThrowsError(try AppConfig(fileName: "testApp7", bundle: Bundle(for: type(of: self)),
                                           appBuildType: "release")) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("No failure for missing features")
            }

            XCTAssertEqual(value, "features")
        }

        // Wrong feature spec
        XCTAssertThrowsError(try AppConfig(fileName: "testApp8", bundle: Bundle(for: type(of: self)),
                                           appBuildType: "release")) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("No failure for wrong feature spec")
            }

            XCTAssertEqual(value, "feature")
        }

        // Wrong view spec
        XCTAssertThrowsError(try AppConfig(fileName: "testApp9", bundle: Bundle(for: type(of: self)),
                                           appBuildType: "release")) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("No failure for wrong view spec")
            }

            XCTAssertEqual(value, "view")
        }

        // Empty features
        XCTAssertThrowsError(try AppConfig(fileName: "testApp10", bundle: Bundle(for: type(of: self)),
                                           appBuildType: "release")) { error in
            guard case ValidationError.missing(let value) = error else {
                return XCTFail("No failure for empty features")
            }

            XCTAssertEqual(value, "features")
        }

    }

    func testInit() {
        if let appConfig = try? AppConfig(fileName: "testApp11", bundle: Bundle(for: type(of: self)),
                                          appBuildType: "release") {
            XCTAssertEqual(appConfig.name, "HelloWorld")
            XCTAssertEqual(appConfig.core, ["AppManager", "ViewManager"])
            XCTAssertEqual(appConfig.views.count, 1)
            XCTAssertEqual(appConfig.features.count, 1)
            //XCTAssertEqual(appConfig.platforms.count, 2);
        } else {
            XCTFail("AppConfig not initialized")
        }

    }

}
