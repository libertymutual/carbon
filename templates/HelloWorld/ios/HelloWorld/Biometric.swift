//
//  Biometric.swift
//  HelloWorld
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
import AppPlatform.BiometricModule
import React

@objc(Biometric)
open class Biometric: NSObject {
    weak var delegate = UIApplication.shared.delegate as? AppDelegate
    private var moduleName = "Biometric"
    @objc
    public func saveCredentials(_ username: String,
                                password: String,
                                resolver resolve: @escaping RCTPromiseResolveBlock,
                                rejecter reject: @escaping RCTPromiseRejectBlock) {
        self.delegate?.biometricModule?.saveCredentials(username: username,
                                                        password: password,
                                                        success: {() -> Void in
            resolve(nil)
        },
                                                        failure: {(reason: String) -> Void in
            reject("ERROR", reason, nil)
        })
    }
    @objc
    public func getCredentials(_ resolve: @escaping RCTPromiseResolveBlock,
                               rejecter reject: @escaping RCTPromiseRejectBlock) {
        self.delegate?.biometricModule?.getCredentials(success: {(results: [String: String]) -> Void in
            resolve(results)
        },
                                                       failure: {(reason: String) -> Void in
            reject("ERROR", reason, nil)
        })
    }
    @objc
    public func deleteCredentials(_ resolve: @escaping RCTPromiseResolveBlock,
                                  rejecter reject: @escaping RCTPromiseRejectBlock) {
        self.delegate?.biometricModule?.deleteCredentials(success: {() -> Void in
            resolve(nil)
        },
                                                          failure: {(reason: String) -> Void in
            reject("ERROR", reason, nil)
        })
    }
    @objc
    public func isSupported(_ resolve: @escaping RCTPromiseResolveBlock,
                            rejecter reject: @escaping RCTPromiseRejectBlock) {
        resolve(self.delegate?.biometricModule?.isSupported())
    }
    @objc
    public func getBiometricType(_ resolve: @escaping RCTPromiseResolveBlock,
                                 rejecter reject: @escaping RCTPromiseRejectBlock) {
        resolve(self.delegate?.biometricModule?.getBiometricType())
    }
    @objc
    public func hasCredentials(_ resolve: @escaping RCTPromiseResolveBlock,
                               rejecter reject: @escaping RCTPromiseRejectBlock) {
        resolve(self.delegate?.biometricModule?.hasCredentials())
    }
}
