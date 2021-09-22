//
//  NetworkError.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation

/// Base struct for network error
struct NetworkError: Error {
    
    /// Not the default network error message, it is defined when using it
    let errorMsg: String
    
    /// Generic error message
    static let genericError = {
        NetworkError(errorMsg: ErrorType.genericError.rawValue)
    }
    
    /// Generic error message
    static let tryAgainError = {
        NetworkError(errorMsg: ErrorType.tryAgainError.rawValue)
    }
}

enum ErrorType: String {
    case genericError = "Something went wrong"
    case tryAgainError = "Try again later"
    case parsingFaild = "Failed in parsing data"
    case requestFailed = "Error processing request"
    case badToken = "Failed to retrieve token"
    case authFailed = "Failed to authenticate"
}
