//
//  NetworkUtilsTests.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import SystemConfiguration
@testable
import AppPlatform

class NetworkUtilsTests: XCTestCase {
    override func setUp() {
        super.setUp()
        NSLog("Connected : " + NetworkUtils.hasNetworkConnection().description)
    }

    override func tearDown() {
        super.tearDown()
    }

    /* Start #determineConnectivity */
    func testSuccessfulConnection() {
        let flags: SCNetworkReachabilityFlags = [SCNetworkReachabilityFlags.reachable]
        let isConnected = NetworkUtils.determineConnectivity(flags: flags)
        XCTAssertTrue(isConnected, "Connected")
    }

    func testUnsuccessfulConnection_Empty() {
        let flags: SCNetworkReachabilityFlags = []
        let isConnected = NetworkUtils.determineConnectivity(flags: flags)
        XCTAssertFalse(isConnected, "Error: Empty Reachability Flag Array should have returned No Connection")
    }

    func testUnsuccessfulConnection_WrongFlags1() {
        let flags: SCNetworkReachabilityFlags = [SCNetworkReachabilityFlags.transientConnection]
        let isConnected = NetworkUtils.determineConnectivity(flags: flags)
        XCTAssertFalse(isConnected, "Error: TransientConnection should have returned No Connection")
    }

    func testUnsuccessfulConnection_WrongFlags2() {
        let flags: SCNetworkReachabilityFlags = [SCNetworkReachabilityFlags.connectionRequired]
        let isConnected = NetworkUtils.determineConnectivity(flags: flags)
        XCTAssertFalse(isConnected, "Error: ConnectionRequired should have returned No Connection")
    }

    func testUnsuccessfulConnection_WrongFlags3() {
        let flags: SCNetworkReachabilityFlags = [SCNetworkReachabilityFlags.connectionAutomatic]
        let isConnected = NetworkUtils.determineConnectivity(flags: flags)
        XCTAssertFalse(isConnected, "Error: ConnectionAutomatic should have returned No Connection")
    }

    func testUnsuccessfulConnection_WrongFlags4() {
        let flags: SCNetworkReachabilityFlags = [SCNetworkReachabilityFlags.connectionOnTraffic]
        let isConnected = NetworkUtils.determineConnectivity(flags: flags)
        XCTAssertFalse(isConnected, "Error: ConnectionOnTraffic should have returned No Connection")
    }

    /* End #determineConnectivity */

    /* Start #getIPv4Socket */

    func testSuccessfulSocketCreation() {
        // Create a socket struct
        var newSocket: sockaddr_in = sockaddr_in()
        newSocket.sin_len = 16
        newSocket.sin_family = 2
        let testSocket: sockaddr_in = NetworkUtils.getIPv4Socket()
        XCTAssertEqual(newSocket.sin_len, testSocket.sin_len)
        XCTAssertEqual(newSocket.sin_family, testSocket.sin_family)
    }

    func testUnsuccessfulSocketCreation() {
        // Create a socket struct
        var newSocket: sockaddr_in = sockaddr_in()
        // Wrong length
        newSocket.sin_len = 0
        // Wrong socket family
        newSocket.sin_family = 0
        let testSocket: sockaddr_in = NetworkUtils.getIPv4Socket()
        XCTAssertNotEqual(newSocket.sin_len, testSocket.sin_len)
        XCTAssertNotEqual(newSocket.sin_family, testSocket.sin_family)
    }

    /* End #getIPv4Socket */

    /* Start #isIPv4SocketReachable */
    func testUnsafePointerSuccess() {
        let socket: sockaddr_in = NetworkUtils.getIPv4Socket()
        let defaultRouteReachability = NetworkUtils.isIPv4SocketReachable(zeroAddress: socket)
        if defaultRouteReachability == nil {
            XCTFail("defaultRouteReachability is null")
        }
    }

    /* End #isIPv4SocketReachable */

    func testIsIPAddress() {
        XCTAssertFalse(NetworkUtils.isIPAddress(hostname: "123.12.1"))
        XCTAssertFalse(NetworkUtils.isIPAddress(hostname: "some-string"))
        XCTAssertFalse(NetworkUtils.isIPAddress(hostname: "123.12.1.x"))
        XCTAssertFalse(NetworkUtils.isIPAddress(hostname: "2001:db8:85a3:8d3:1319:8a2e:370:wxyz"))

        XCTAssertTrue(NetworkUtils.isIPAddress(hostname: "123.12.1.1"))
        XCTAssertTrue(NetworkUtils.isIPAddress(hostname: "2001:db8:85a3:8d3:1319:8a2e:370:7348"))
    }
}
