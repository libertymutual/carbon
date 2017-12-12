//
//  AuthApiError.swift
//  AppPlatform

import Foundation

public enum AuthApiError: Error {
    case invalidCredentials
    case invalidResponse
    case serverMessage(message: String)
    case server
}

extension AuthApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid Credentials"
        case .invalidResponse:
            return "Invalid Response"
        case .serverMessage(let message):
            return "Server \(message)"
        case .server:
            return "Server Error"
        }
    }
}
