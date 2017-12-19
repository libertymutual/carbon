//
//  ViewTests.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

final public class ExampleView: View {
    public var viewController: UIViewController?
    public var name: String = "example-view"

    public init() {}

    public func loadViewController(config: ViewConfig) -> UIViewController {
        return UIViewController()
    }

}

class ViewTests: XCTestCase {

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

        if let view = try? ExampleView(config: ViewConfig(attributes: attributes)) {
            XCTAssertEqual(view.name, "example-view")
            XCTAssertNotNil(view.viewController)
        } else {
            XCTFail("ExampleView not loaded")
        }
    }

}
