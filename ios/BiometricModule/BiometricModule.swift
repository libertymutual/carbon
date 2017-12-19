//
//  BiometricModule.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
import KeychainAccess
import LocalAuthentication

public class BiometricModule {
    var keychain: Keychain

    public init() {
        keychain = Keychain(service: "com.lmig.uscm.digital.AppPlatform")
            .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
            .authenticationPrompt("Plase authenticate to continue")
    }

    public func saveCredentials(username: String,
                                password: String,
                                success: @escaping () -> Void,
                                failure: @escaping (String) -> Void) {
        var creds = [String: String]()
        creds["username"] = username
        creds["password"] = password
        let credsData = NSKeyedArchiver.archivedData(withRootObject: creds)
        DispatchQueue.global().async {
            do {
                try self.keychain.set(credsData, key: "credentials")
                success()
            } catch {
                failure("Unable to save credentials")
            }
        }
    }

    public func getCredentials(success: @escaping ([String: String]) -> Void, failure: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            do {
                let creds = try self.keychain.getData("credentials")
                if let creds = creds {
                    let unarchivedDictionary = NSKeyedUnarchiver.unarchiveObject(with: creds)
                    if let unarchivedDictionary = unarchivedDictionary {
                        if let unarchivedDictionary = unarchivedDictionary as? [String: String] {
                            success(unarchivedDictionary)
                        } else {
                            failure("Unable to retrieve credentials")
                        }
                    } else {
                        failure("Unable to retrieve credentials")
                    }
                } else {
                    failure("Unable to retrieve credentials")
                }
            } catch {
                failure("Unable to retrieve credentials")
            }
        }
    }

    public func deleteCredentials(success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            do {
                try self.keychain.remove("credentials")
                success()
            } catch {
                failure("Unable to delete credentials")
            }
        }
    }

    public func isSupported() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    public func getBiometricType() -> String {
        // IMPORTANT: This function assumes you have already called "isSupported" to verify that
        // Biometric Authentication of any type is supported.
        // Calling this function on its own will always return "none", "face" or "fingerprint"
        // even if no facial / fingerprint recognition hardware is present on the device
        let context = LAContext()
        var error: NSError?

        if(context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)) {
            if #available(iOS 11.0, *) {
                switch context.biometryType {
                case .none:
                    return "none"
                case .faceID:
                    return "face"
                case .touchID:
                    return "fingerprint"
                }
            }
            return "fingerprint"
        } else {
            return "none"
        }
    }

    public func hasCredentials() -> Bool {
        let keychainQuery: [AnyHashable: Any] = [
            kSecClass as AnyHashable: kSecClassGenericPassword,
            kSecAttrService as AnyHashable: "com.lmig.uscm.digital.AppPlatform",
            kSecAttrAccount as AnyHashable: "credentials",
            kSecUseAuthenticationUI as AnyHashable: kSecUseAuthenticationUIFail
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)

        switch status {
        case errSecSuccess, errSecInteractionNotAllowed:
            return true
        case errSecItemNotFound, errSecAuthFailed:
            return false
        default:
            return false
        }
    }
}
