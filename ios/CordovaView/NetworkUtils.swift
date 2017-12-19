//
//  NetworkUtils.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import Foundation
import SystemConfiguration

//
//  NetworkUtils.m
//  LibertyMutual
//
//  01/07/11    -     Written in Objective-C
//  05/26/16    -     Rewritten in Swift
//
//  Copyright 2011 Liberty Mutual. All rights reserved.

/// Utility class for determining network connectivity
public class NetworkUtils {

    /**
     Main Access point for determining if device has network connectivity
     
     - Returns: true if device has an internet connection
     */
    public class func hasNetworkConnection() -> Bool {

        let zeroAddress: sockaddr_in = getIPv4Socket()

        /// Can we reach an IPv4 address?
        let defaultRouteReachability = isIPv4SocketReachable(zeroAddress: zeroAddress)

        if defaultRouteReachability == nil {
            return false
        }

        // Determines in-depth status of internet connectivity
        // Ex. isReachable, ConnectionRequired
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }

        return determineConnectivity(flags: flags)

    }

    /**
     Analyze Network status and determine whether or not we have a network connection
     
     - Returns: true if there is a network connection
     */
    public class func determineConnectivity(flags: SCNetworkReachabilityFlags) -> Bool {

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)

    }

    /**
     Obtain reference to IPv4 Socket
     
     - Returns: socket object
     */
    public class func getIPv4Socket() -> sockaddr_in {

        // Create a socket struct
        var newSocket = sockaddr_in()
        newSocket.sin_len = UInt8(MemoryLayout.size(ofValue: newSocket))
        // Set socket type to IPv4
        newSocket.sin_family = sa_family_t(AF_INET)
        return newSocket
    }

    /**
     Determine if we can reach IPv4 Socket
     
     - Returns: SCNetworkReachability object if IPv4 socket can be reached
     */
    public class func isIPv4SocketReachable(zeroAddress: sockaddr_in) -> SCNetworkReachability? {

        var newZeroAddress = zeroAddress
        let defaultRouteReachability = withUnsafePointer(to: &newZeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        return defaultRouteReachability
    }

    /**
     Determine if the hostname is IP address
     
     - Parameter hostname: string we want to check
     - Returns: true if hostname parameter is an actual IP address
     */
    public class func isIPAddress(hostname: String) -> Bool {
        var sin = sockaddr_in()
        var sin6 = sockaddr_in6()

        if hostname.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
            // IPv6 peer.
            return true
        } else if hostname.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            // IPv4 peer.
            return true
        }

        return false
    }
}
