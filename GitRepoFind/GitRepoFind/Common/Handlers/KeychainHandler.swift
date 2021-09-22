//
//  KeychainHandler.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 22/09/2021.
//

import Security
import UIKit

let AUTH_TOKEN = "authToken"

enum KeychainError: Error {
    
    /// Attempted read for an item that does not exist.
    case itemNotFound
    
    /// Attempted save to override an existing item.
    /// Use update instead of save to update existing items
    case duplicateItem
    
    /// A read of an item in any format other than Data
    case invalidItemFormat
    
    /// Any operation result status than errSecSuccess
    case unexpectedStatus(OSStatus)
}

class KeyChain {
    
    private init() {}
    static let shared: KeyChain = {
        return KeyChain()
    } ()

    func save(key: String, value: String) throws {
        
        let tag = value.data(using: .utf8)!
        let addQuery: [String : Any] = [kSecClass as String : kSecClassKey,
                                       kSecAttrApplicationTag as String : tag,
                                       kSecValueRef as String : key]
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else { throw KeychainError.unexpectedStatus(status) }
    }

    func load(tag: String) throws -> Data? {
        let getQuery: [String : Any] = [kSecClass as String : kSecClassKey,
                                       kSecAttrApplicationTag as String : tag,
                                       kSecAttrKeyType as String : kSecAttrKeyTypeRSA,
                                       kSecReturnRef as String : true]

        var dataTypeRef: AnyObject? = nil

        let status = SecItemCopyMatching(getQuery as CFDictionary, &dataTypeRef)

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
            
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        guard let value = dataTypeRef as? Data else {
            throw KeychainError.invalidItemFormat
        }

        return value
    }
}
