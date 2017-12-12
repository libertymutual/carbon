//
//  HelloWorldUITests.swift
//  HelloWorldUITests
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest

class HelloWorldUITests: XCTestCase {
    // UI tests must launch the application that they test. Doing this in setup will
    // make sure it happens for each test method.
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launchEnvironment = ProcessInfo.processInfo.environment
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your
        // tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNavigateToSecondFeature() {
        // This is a very simple UI test example.
        // It simply tests that navigation between two features works as expected.
        // You can/should add your own full suite of UI Tests
      //  XCUIApplication().buttons["Another Feature"].tap()
      //  XCTAssert(XCUIApplication().staticTexts["Welcome To The Second Feature Home Screen"].exists)
    }

}
