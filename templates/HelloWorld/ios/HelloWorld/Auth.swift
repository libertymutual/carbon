//
//  Auth.swift
//  HelloWorld
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
import AppPlatform.AuthModule
import React

@objc(Auth)
open class Auth: NSObject {
    weak var delegate = UIApplication.shared.delegate as? AppDelegate
    private let moduleName = "Auth"
    private let authConfigsFilename = "authConfigs"

    @objc
    public func configure(_ name: String,
                          authURL: String,
                          clientId: String,
                          clientSecret: String,
                          validatorId: String,
                          resolver resolve: @escaping RCTPromiseResolveBlock,
                          rejecter reject: @escaping RCTPromiseRejectBlock) {

        AuthModule.sharedInstance.configureWithCredentials(name: name,
                                                           authURL: authURL,
                                                           clientId: clientId,
                                                           clientSecret: clientSecret,
                                                           validatorId: validatorId)
        resolve(nil)
    }

    @objc
    public func configureWithEnvironmentKey(_ key: String,
                                            resolver resolve: @escaping RCTPromiseResolveBlock,
                                            rejecter reject: @escaping RCTPromiseRejectBlock) {

        let successHandler: () -> Void = {
            resolve(nil)
        }

        AuthModule.sharedInstance.configureWithCredentials(fileName: authConfigsFilename,
                                           inBundle: Bundle.main,
                                           configName: key,
                                           successHandler: successHandler,
                                           errorHandler: generateErrorHandler(rejector: reject))
    }

    @objc
    public func login(_ username: String,
                      password: String,
                      resolver resolve: @escaping RCTPromiseResolveBlock,
                      rejecter reject: @escaping RCTPromiseRejectBlock) {
        let successHandler: () -> Void = {
            resolve(AuthModule.sharedInstance.isAuthenticated())
        }

        AuthModule.sharedInstance.auth(username: username,
                                       password: password,
                                       successHandler: successHandler,
                                       errorHandler: generateErrorHandler(rejector: reject))
    }

    @objc
    public func logout(_ resolve: @escaping RCTPromiseResolveBlock,
                       rejecter reject: @escaping RCTPromiseRejectBlock) {
        AuthModule.sharedInstance.logout()
        resolve(nil)
    }

    @objc
    public func getAccessToken(_ resolve: @escaping RCTPromiseResolveBlock,
                               rejecter reject: @escaping RCTPromiseRejectBlock) {
        let successHandler: (String) -> Void = { token in
            resolve(token)
        }

        AuthModule.sharedInstance.getAccessToken(successHandler: successHandler,
                                                 errorHandler: generateErrorHandler(rejector: reject))
    }

    @objc
    public func getExpiresIn(_ resolve: @escaping RCTPromiseResolveBlock,
                             rejecter reject: @escaping RCTPromiseRejectBlock) {
        resolve(AuthModule.sharedInstance.getExpiresIn())
    }

    @objc
    public func getUsername(_ resolve: @escaping RCTPromiseResolveBlock,
                            rejecter reject: @escaping RCTPromiseRejectBlock) {
        resolve(AuthModule.sharedInstance.getUsername())
    }

    @objc
    public func getEmail(_ resolve: @escaping RCTPromiseResolveBlock,
                         rejecter reject: @escaping RCTPromiseRejectBlock) {
        resolve(AuthModule.sharedInstance.getEmail())
    }

    @objc
    public func isAuthenticated(_ resolve: @escaping RCTPromiseResolveBlock,
                                rejecter reject: @escaping RCTPromiseRejectBlock) {
        resolve(AuthModule.sharedInstance.isAuthenticated())
    }

    func generateErrorHandler(rejector reject: @escaping RCTPromiseRejectBlock) -> (Error) -> Void {
        return { error in
            let error = error as NSError
            reject(String(error.code), error.localizedDescription, error)
        }
    }
}
