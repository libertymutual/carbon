//
//  AuthModuleTests.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import AppPlatform

class AuthModuleTests: XCTestCase {
    var authModuleConfig: AuthModuleConfig?
    // swiftlint:disable line_length
    let expectedToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6W10sImNsaWVudF9pZCI6InVzY21fbG1tb2JpbGVfZGV2IiwiZW1haWwiOiJjb3Jkb3ZhQHRlc3QuY29tIiwidXNlcm5hbWUiOiJsbWFwcGNvcmRvdmEiLCJleHAiOjU1MDQwMjQ4MzZ9.eXkCi68m6tEG2U1h_s3U4Hj8Z3QnNc1ddBEErVs7gQI"
    let expectedExpiredToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6W10sImNsaWVudF9pZCI6InVzY21fbG1tb2JpbGVfZGV2IiwiZW1haWwiOiJjb3Jkb3ZhQHRlc3QuY29tIiwidXNlcm5hbWUiOiJsbWFwcGNvcmRvdmEiLCJleHAiOjB9.J-lYxcjLpEiMwX8vzg8bNiv7iX8VKlfRQV43kf6h7rk"
    // swiftlint:enable line_length

    func generateErrorHandler() -> (Error) -> Void {
        return { error in
            XCTFail("Error: \(error)")
        }
    }

    override func setUp() {
        super.setUp()

        let attributes = ["authURL": "https://www.example.org/auth",
                          "clientId": "abc",
                          "clientSecret": "s3cr3t",
                          "validatorId": "dss"]
        if let authModuleConfig = try? AuthModuleConfig(attributes: attributes) {
            self.authModuleConfig = authModuleConfig

        } else {
            XCTFail("AuthModuleConfig not initialized")
        }
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()

        super.tearDown()
    }

    func testInit() {
        if self.authModuleConfig != nil {
            let authModule = AuthModule.sharedInstance
            authModule.configure(authModuleConfig: self.authModuleConfig!)
        } else {
            XCTFail("AuthModuleConfig not initialized")
        }
    }

    func testAuth() {
        let expectation = self.expectation(description: "send auth request")
        stub(condition: isHost("www.example.org")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("auth.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
            }.name = "Auth"

        let authModule = AuthModule.sharedInstance

        let loginSuccessHandler : () -> Void = {
            XCTAssertTrue(authModule.isAuthenticated())
            XCTAssertGreaterThan(authModule.getExpiresIn(), 2000)
            XCTAssertEqual(authModule.getRefreshToken(), "9BG4Whm4Ku4szAbxixzHgotbHlqgKfuzjNFZpn4xkW")
            XCTAssertEqual(authModule.getUsername(), "lmappcordova")
            XCTAssertEqual(authModule.getEmail(), "cordova@test.com")

            let tokenSuccessHandler: (String) -> Void = { token in
                XCTAssertEqual(token, self.expectedToken)
                expectation.fulfill()
            }

            authModule.getAccessToken(
                successHandler: tokenSuccessHandler,
                errorHandler: self.generateErrorHandler())
        }

        authModule.configure(authModuleConfig: self.authModuleConfig!)

        authModule.auth(username: "lmappcordova",
                        password: "testing1",
                        successHandler: loginSuccessHandler,
                        errorHandler: self.generateErrorHandler())

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testAuthFailure() {
        let authModule = AuthModule.sharedInstance

        let expectation = self.expectation(description: "send auth request")
        stub(condition: isHost("www.example.org")) { _ in
            let stubData = "Some error".data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(
                data: stubData!,
                statusCode: 400,
                headers: ["Content-Type": "application/json"]
            )
        }

        let loginFailureHandler: (Error) -> Void = { _ in
            XCTAssertFalse(authModule.isAuthenticated())
            XCTAssertEqual(authModule.getExpiresIn(), 0)
            expectation.fulfill()
        }

        let loginSuccessHandler: () -> Void = {
            XCTFail("Login was not supposed to succeed")
        }

        authModule.configure(authModuleConfig: authModuleConfig!)

        authModule.auth(username: "lmappcordova",
                        password: "testing1",
                        successHandler: loginSuccessHandler,
                        errorHandler: loginFailureHandler)

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testExpired() {
        let authModule = AuthModule.sharedInstance

        let expectation = self.expectation(description: "send auth request")
        stub(condition: isHost("www.example.org")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("auth-expired.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
            }.name = "Auth"

        let tokenHandler: (String) -> Void = { token in
            XCTAssertEqual(token, self.expectedExpiredToken)
            expectation.fulfill()
        }

        let loginSuccessHandler:() -> Void = {
            XCTAssertEqual(authModule.getExpiresIn(), 0)
            XCTAssertEqual(authModule.getRefreshToken(), "9BG4Whm4Ku4szAbxixzHgotbHlqgKfuzjNFZpn4xkW")
            authModule.getAccessToken(successHandler: tokenHandler, errorHandler: self.generateErrorHandler())
        }

        authModule.configure(authModuleConfig: self.authModuleConfig!)

        authModule.auth(username: "lmappcordova",
                        password: "testing1",
                        successHandler: loginSuccessHandler,
                        errorHandler: self.generateErrorHandler())

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testRefresh() {
        let authModule = AuthModule.sharedInstance
        let expectation = self.expectation(description: "send auth request")
        stub(condition: isHost("www.example.org")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("auth.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
            }.name = "Auth"

        let refreshSuccesHandler: (String) -> Void = { token in
            XCTAssertEqual(authModule.getRefreshToken(), "9BG4Whm4Ku4szAbxixzHgotbHlqgKfuzjNFZpn4xkW")
            expectation.fulfill()
        }

        let loginSuccessHandler: () -> Void = {
            authModule.refresh(successHandler: refreshSuccesHandler, errorHandler: self.generateErrorHandler())
        }

        authModule.configure(authModuleConfig: authModuleConfig!)
        authModule.auth(username: "lmappcordova",
                        password: "testing1",
                        successHandler: loginSuccessHandler,
                        errorHandler: self.generateErrorHandler())

        self.waitForExpectations(timeout: 5.0, handler: nil)

    }
}

