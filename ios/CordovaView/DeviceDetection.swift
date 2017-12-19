//
//  DeviceDetection.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//
import Foundation
import UIKit

/// DeviceDetection, well..., detects the iOS Device Types and categorizes them as:
///
/// **smartphone**
///  - iPhones
///  - iPods
///
/// **tablet**
///  - iPads
///
/// - returns: "smartphone" or "tablet"
public class DeviceDetection {

    // Options for Device Types
    public enum DeviceType: String {
        case smartphone
        case tablet
    }

    // Keys for our DeviceInfo dictionary
    struct DeviceInfoKey {
        static let type = "type"
        static let id = "id" // swiftlint:disable:this identifier_name
        static let userDefaults = "deviceInfo"
    }

    static let defaultDeviceType = DeviceType.smartphone
    static var savedDeviceInfo: NSDictionary?

    /**
     Entry point for determine Device Type (smartphone or tablet)

     - returns: smartphone or tablet `String`
     */
    public class func getDeviceType() -> String {
        if isInitialized() {
            return retrieveTypeFromCachedUsedDefaults()
        }

        savedDeviceInfo = determineDeviceInfo()

        if !isDeviceInfoAvailable() || !isSameDeviceID(deviceInfo: savedDeviceInfo!) {
            saveDeviceInfo(deviceInfo: savedDeviceInfo)
        }

        return retrieveTypeFromCachedUsedDefaults()
    }

    /**
     Use cached copy of User Defaults to retrieve device type
 
     - returns: Smartphone or tablet `String`
     */
    class func retrieveTypeFromCachedUsedDefaults() -> String {
        if isInitialized(), let type = savedDeviceInfo!.value(forKey: DeviceInfoKey.type) as? String {
            return type
        } else {
            // TODO Replace with logger
            print("Failed to retrieve Device Info from User Defaults. Default to smartphone")
            return DeviceType.smartphone.rawValue
        }
    }

    /**
     Execute logic to determine whether device is a smartphone or a tablet

     - returns: `NSDictionary` containing device type (smartphone, tablet) and `deviceInfo` (UUID)
     */
    class func determineDeviceInfo() -> NSDictionary! {
        var deviceType: String

        switch UI_USER_INTERFACE_IDIOM() {
        case .pad:
            deviceType = DeviceType.tablet.rawValue
            break

        case .phone:
            deviceType = DeviceType.smartphone.rawValue
            break
        default:
            NSLog("Unknown device detected. Defaulting to " + defaultDeviceType.rawValue)
            deviceType = DeviceType.smartphone.rawValue
        }

        let deviceId: String = UIDevice.current.identifierForVendor!.uuidString

        let key = DeviceInfoKey.type
        let deviceInfo: NSDictionary! = [ key: deviceType, DeviceInfoKey.id: deviceId ]
        return deviceInfo
    }

    /**
     We know that device info has been saved in UserDefaults
     But it's possible the user has a new device

     - returns: true if current device is the same as last one used, false otherwise
     */
    class func isSameDeviceID(deviceInfo: NSDictionary) -> Bool {
        // swiftlint:disable force_cast
        let storedDeviceID = deviceInfo.value(forKey: DeviceInfoKey.id) as! String
        // swiftlint:enable force_cast
        let currentDeviceID = UIDevice.current.identifierForVendor!.uuidString
        return (currentDeviceID == storedDeviceID)
    }

    /**
     Have we previously set the device type in `UserDefaults?`
     
     - returns: `true` if `deviceInfo` key is present in `UserDefaults`, `false` otherwise
     */
    class func isDeviceInfoAvailable() -> Bool {
        let defaults = UserDefaults.standard
        let deviceInfo = defaults.object(forKey: DeviceInfoKey.userDefaults)
        return deviceInfo != nil
    }

    /**
     Retrieve device info from User Defaults
     
     - returns: `String` value for `deviceInfo` key
     */
    class func getDeviceInfoFromUserDefaults() -> String! {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: DeviceInfoKey.userDefaults) as? String
    }

    /**
     Set device info in user defaults
     */
    class func saveDeviceInfo(deviceInfo: NSDictionary!) {
        NSLog("Saving device info to user defaults: %@", deviceInfo)
        let defaults = UserDefaults.standard
        defaults.set(deviceInfo, forKey:DeviceInfoKey.userDefaults)
        defaults.synchronize()
    }

    /**
     Is this the first time wee've run on this device?
     */
    class func isInitialized() -> Bool {
        return savedDeviceInfo != nil
    }
}
