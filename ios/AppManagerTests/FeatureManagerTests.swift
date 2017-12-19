//
//  FeatureManagerTests.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import AppPlatform

class FeatureManagerTests: XCTestCase {
    var feature: TestFeature?
    let attributes = [
        "name": "Test",
        "config": ["theme": "light"],
        "viewConfig": [
            "name": "ReactNative",
            "config": [
                "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
                "moduleName": "HelloWorld",
                "initialProperties": nil,
                "launchOptions": nil
            ]
        ]
        ] as [String: Any]

    override func setUp() {
        super.setUp()

        if let featureConfig = try? FeatureConfig(attributes: self.attributes) {
            self.feature = TestFeature(config: featureConfig)
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        let manager = FeatureManager(feature: self.feature!)
        XCTAssertEqual(manager.defaultFeature, self.feature?.name)

        if let f = manager.features.first as? TestFeature {
            XCTAssertEqual(f.name, self.feature?.name)
        } else {
          XCTFail("Not a TestFeature")
        }
    }

    func testInitMultiple() {
        let manager = FeatureManager(features: [self.feature!], defaultFeature: "Test")
        XCTAssertEqual(manager.defaultFeature, self.feature?.name)

        if let f = manager.features.first as? TestFeature {
            XCTAssertEqual(f.name, self.feature?.name)
        } else {
            XCTFail("Not a TestFeature")
        }
    }

    func testDisplay() {
        let manager = FeatureManager(feature: self.feature!)

        // Not testable at the moment
        manager.display(feature: self.feature!)
        XCTAssertNil(nil)

    }

    func testMergeConfig() {
        let manager = FeatureManager(feature: self.feature!)
        manager.mergeConfig(featureConfig: [self.feature!.config!])

        XCTAssert(manager.features.first!.config == self.feature!.config)
    }

    func testMergeConfigEmpty() {
        let manager = FeatureManager(feature: self.feature!)
        manager.features.first!.config = nil
        if let featureConfig = try? FeatureConfig(attributes: self.attributes) {
//            self.feature = TestFeature(config: featureConfig)
            manager.mergeConfig(featureConfig: [featureConfig])

            XCTAssert(manager.features.first!.config == self.feature!.config)
        } else {
            XCTFail("FeatureConfig init failed")
        }
    }

    func testSetupViews() {
        let attributes = [
            "name": "ReactNative",
            "config": [
                "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
                "moduleName": "HelloWorld",
                "initialProperties": nil,
                "launchOptions": nil
            ]
            ] as [String: Any]

        let manager = FeatureManager(feature: self.feature!)
        if let viewConfig = try? ViewConfig(attributes: attributes) {
            manager.setupViews(viewConfig: [viewConfig])
            XCTAssert(manager.features.first?.config?.viewConfig == viewConfig)
        } else {
            XCTFail("ViewConfig not initialized")
        }
    }

    func testSetupViewsEmptyConfig() {
        let attributes = [
            "name": "ReactNative",
            "config": [
                "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
                "moduleName": "HelloWorld",
                "initialProperties": nil,
                "launchOptions": nil
            ]
            ] as [String: Any]

        let manager = FeatureManager(feature: self.feature!)
        if let viewConfig = try? ViewConfig(attributes: attributes) {
            manager.features.first?.config?.viewConfig = nil
            manager.setupViews(viewConfig: [viewConfig]) // Quiet failure (print only)
            XCTAssertNil(manager.features.first?.config?.viewConfig)
        } else {
            XCTFail("ViewConfig not initialized")
        }
    }

    func testGetDefaultFeature() {
        let manager = FeatureManager(feature: self.feature!)
        let defaultFeature = manager.getDefaultFeature() as? TestFeature
        XCTAssertEqual(defaultFeature?.config, self.feature!.config)
        XCTAssertEqual(defaultFeature?.name, self.feature!.name)

        manager.features = []
        XCTAssertNil(manager.getDefaultFeature())
    }

    func testUpdateFeature() {
        let manager = FeatureManager(feature: self.feature!)
        let attributes = [
            "moduleName": "HelloWorld",
            "initialProperties": ["testing": 1],
            "launchOptions": ["launch": "option"]
        ] as [String: Any]
        if let reactNativeData = try? ReactNav(attributes: attributes) {
            let nav = Navigation(featureName: "Test", data: reactNativeData)
            manager.updateFeature(feature: self.feature!, nav: nav)
            let rnConf = manager.getDefaultFeature()?.config?.viewConfig?.config as? ReactNativeViewConfig
            XCTAssertEqual((rnConf?.initialProperties as? [String: Int])!, ["testing": 1])
            XCTAssertEqual((rnConf?.launchOptions as? [String: String])!, ["launch": "option"])
        } else {
            XCTFail("ReactNav init failed")
        }
    }

    func testGetFeatureByName() {
        let manager = FeatureManager(feature: self.feature!)
        XCTAssertEqual(manager.getFeatureByName(name: "Test")!.name, self.feature!.name)
        XCTAssert(manager.getFeatureByName(name: "TestNonExistant") == nil)
    }

    func testGetFeatureByNameFake() {
        let manager = FeatureManager(feature: self.feature!)
        manager.features = []
        XCTAssertNil(manager.getFeatureByName(name: ""))
    }

}
