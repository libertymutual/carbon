//
//  Authentication.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
import Alamofire
import JWTDecode

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
}

/// Authentication module
public class AuthModule {
    private var authModuleConfig: AuthModuleConfig?
    private var accessToken: String?
    private var refreshToken: String?
    private var expiresAt: Date = Date()
    private var authenticated: Bool = false
    private var email: String?
    private var username: String?

    private init() {}

    public static let sharedInstance = AuthModule()

    /**
     Initialization method that sets the config
     
     - parameter authModuleConfig: `AuthModuleConfig` used for initialization
     - returns: `Void`
     */
    public func configure(authModuleConfig: AuthModuleConfig) {
        self.authModuleConfig = authModuleConfig

    }

    /**
     Generate new AuthModule with specified configuration values. Creates a config & then calls init.

     - parameter name
     - parameter authURL
     - parameter clientId
     - parameter clientSecret
     - paremeter validatorId
     - returns: `Void`
     */
    public func configureWithCredentials(name: String,
                                         authURL: String,
                                         clientId: String,
                                         clientSecret: String,
                                         validatorId: String) {

        let config = AuthModuleConfig(name: name,
                                      authURL: authURL,
                                      clientId: clientId,
                                      clientSecret: clientSecret,
                                      validatorId: validatorId)
        configure(authModuleConfig: config)
    }

    /**
     Generate new AuthModule by parsing auth configs in a file and finding the config with specified name.
     Calls init once the config is parsed.

     - parameter fileName: name of the file to be parsed (defaults to 'authConfigs.json')
     - parameter inBundle: Bundle in which the file exists
     - parameter configName: name of the configuration to find in the file
     - parameter successHandler: execute on success
     - parameter errorHandler: execute and pass 'Error' on failure
     - returns: `Void`
     */
    public func configureWithCredentials(fileName: String = "authConfigs",
                                         inBundle bundle: Bundle,
                                         configName: String,
                                         successHandler: @escaping (() -> Void),
                                         errorHandler: @escaping ((Error) -> Void),
                                         fetchAnonymousToken: Bool = true) {
        do {
            if let authConfigDict = try AuthModuleConfig.getConfigDict(inFile: fileName,
                                                                       matchingKey: configName,
                                                                       inBundle: bundle) {
                let authConfig = try AuthModuleConfig(attributes: authConfigDict)
                configure(authModuleConfig: authConfig)
                successHandler()
            }
        } catch let error {
            errorHandler(error)
        }
    }

    /**
     Logs the user out by nilling out instance vars
     */
    public func logout() {
        self.accessToken = nil
        self.refreshToken = nil
        self.authenticated = false
        self.email = nil
        self.username = nil
    }

    /**
     Method for authenticating users. Once the request is made by using method and config parameters, 
     it asyncronously returns self to completion handler.
     
     - parameter username: `String` username of a user
     - parameter password: `String` user's password
     - parameter successHandler: execute on success
     - parameter errorHandler: execute and pass 'Error' on failure
     - returns: `Void`
     */
    public func auth(username: String,
                     password: String,
                     successHandler: @escaping (() -> Void),
                     errorHandler: @escaping ((Error) -> Void)) {

        guard let authModuleConfig = self.authModuleConfig else {
            errorHandler(AuthApiError.invalidCredentials)
            return
        }

        let parameters: Parameters = [
            "grant_type": "password",
            "username": username,
            "password": password,
            "validator_id": authModuleConfig.validatorId,
            "client_id": authModuleConfig.clientId,
            "client_secret": authModuleConfig.clientSecret
        ]
        let tokenHandler: (_ token: String) -> Void = { _ in
            successHandler()
        }
        self.httpRequest(parameters: parameters, successHandler: tokenHandler, errorHandler: errorHandler)
    }

    /**
     Attempt a refresh if a refresh token is available, if not, try to get an anonymous token
     
     - parameter authHandler: closure with an `AuthModule` object as parameter
     - parameter successHandler: execute on success and pass in a token String
     - parameter errorHandler: execute and pass 'Error' on failure
     - returns: `Void`
     */
    public func refresh(successHandler: @escaping ((String) -> Void),
                        errorHandler: @escaping ((Error) -> Void)) {

        guard let authModuleConfig = self.authModuleConfig else {
            errorHandler(AuthApiError.invalidCredentials)
            return
        }

        if let refreshToken = self.getRefreshToken() {
            let parameters: Parameters = [
                "grant_type": "refresh_token",
                "validator_id": authModuleConfig.validatorId,
                "client_id": authModuleConfig.clientId,
                "client_secret": authModuleConfig.clientSecret,
                "refresh_token": refreshToken
            ]
            self.httpRequest(parameters: parameters, successHandler: successHandler, errorHandler: errorHandler)
        } else {
            self.anonymous(successHandler: successHandler, errorHandler: errorHandler)
        }
    }

    /**
     Method for getting a token for anonymous users. Once the request is made by using method and config parameters,
     it asyncronously returns self to completion handler.
     - parameter successHandler: execute on success and pass in a token String
     - parameter errorHandler: execute and pass 'Error' on failure
     - returns: `Void`
     */
    public func anonymous(successHandler: @escaping ((String) -> Void),
                          errorHandler: @escaping ((Error) -> Void)) {

        guard let authModuleConfig = self.authModuleConfig else {
            errorHandler(AuthApiError.invalidCredentials)
            return
        }

        let parameters: Parameters = [
            "grant_type": "client_credentials",
            "validator_id": authModuleConfig.validatorId,
            "client_id": authModuleConfig.clientId,
            "client_secret": authModuleConfig.clientSecret
        ]

        self.httpRequest(parameters: parameters,
                         successHandler: successHandler,
                         errorHandler: errorHandler)
    }

    /**
     Calls Auth service to get the token.
     
     - parameter parameters: `Parameters` to be sent with the request
     - parameter successHandler: execute on success and pass the token String
     - parameter errorHandler: execute and passs 'Error' on failure
     - returns: `Void`
     */
    func httpRequest(parameters: Parameters,
                     successHandler: @escaping ((String) -> Void),
                     errorHandler: @escaping ((Error) -> Void)) {
        guard let authModuleConfig = self.authModuleConfig else {
            errorHandler(AuthApiError.invalidCredentials)
            return
        }

        Alamofire.request(authModuleConfig.authURL, method: .post, parameters: parameters)
            .debugLog()
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [String: AnyObject] {
                        if let at = json["access_token"] as? String {
                            do {
                             try self.setAccessToken(accessToken: at)
                            } catch let error {
                                errorHandler(error)
                                return
                            }
                        }
                        if let rt = json["refresh_token"] as? String {
                            self.setRefreshToken(refreshToken: rt)
                        }
                    } else {
                        self.authenticated = false
                        self.expiresAt = Date()
                        errorHandler(AuthApiError.invalidResponse)
                        return
                    }
                    if let accessToken = self.accessToken {
                        successHandler(accessToken)
                    } else {
                        errorHandler(AuthApiError.invalidResponse)
                    }
                case .failure(let error):
                    self.expiresAt = Date()
                    self.authenticated = false
                    errorHandler(error)
                }
        }
    }

    /**
     Determines if user is authenticated (if a username exists & the token has not expired)

     - returns: `Bool` is user authenticated?
     */
    public func isAuthenticated() -> Bool {
        if self.username == nil || self.expiresAt < Date() {
            self.authenticated = false
        }
        return self.authenticated
    }

    /**
     Gets the access token
     - parameter successHandler: execute on success passing the token String
     - parameter errorHandler: execute and psss 'Error' on failure
     - returns: `String` access token
     */
    public func getAccessToken(successHandler: @escaping ((String) -> Void),
                               errorHandler: @escaping ((Error) -> Void)) {
        // if we have an access token & it won't expire soon
        if let token = accessToken, getExpiresIn() > 6300 { // 120 - 15 minutes
            successHandler(token)
        } else {
            refresh(successHandler: successHandler, errorHandler: errorHandler)
        }
    }

    /**
     Sets the access token, throws an `AuthApiError.invalidResponse` if jwt parsing fails
     
     - parameter accessToken: `String` to be set as an access token
     - returns: `void`
     */
    private func setAccessToken(accessToken: String) throws {
        guard let jwt = try? decode(jwt: accessToken) else {
            throw AuthApiError.invalidResponse
        }

        if let jwtExpiresAt = jwt.expiresAt {
            self.expiresAt = jwtExpiresAt
        } else {
           throw AuthApiError.invalidResponse
        }

        let emailClaim = jwt.claim(name: "email")
        if let email = emailClaim.string {
            self.email = email
        } else {
            self.email = nil
        }

        let usernameClaim = jwt.claim(name: "username")
        if let username = usernameClaim.string {
            self.username = username
            self.authenticated = true
        } else {
            self.username = nil
            self.authenticated = false
        }
        self.accessToken = accessToken
    }

    /**
     Gets the refresh token
     
     - returns: `String` refresh token
     */
    func getRefreshToken() -> String? {
        return self.refreshToken
    }

    /**
     Sets the refresh token
     
     - parameter refreshToken: `String` to be set as an refresh token
     - returns: `void`
     */
    private func setRefreshToken(refreshToken: String) {
        // TODO: Set to permanent storage
        self.refreshToken = refreshToken
    }

    /**
     Gets time duration token is still valid
     
     - returns: `Int` token valid in seconds
     */
    public func getExpiresIn() -> Int {
        let epochDiff = self.expiresAt.timeIntervalSince1970 - Date().timeIntervalSince1970
        if epochDiff < 0 {
            return 0
        }
        return Int(epochDiff)
    }

    /**
     Gets the username if set
     
     - returns: `String?` username
     */
    public func getUsername() -> String? {
        return self.username
    }

    /**
     Gets the email if set
     
     - returns: `String?` email
     */
    public func getEmail() -> String? {
        return self.email
    }
}
