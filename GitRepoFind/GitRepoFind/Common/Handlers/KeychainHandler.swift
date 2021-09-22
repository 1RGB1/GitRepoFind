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

    func save(key: String, value: String) {
        
        let data = value.data(using: .utf8, allowLossyConversion: false)!
        
        let addQuery: [String : Any] = [kSecClass as String : kSecClassGenericPassword,
                                       kSecAttrAccount as String : key,
                                       kSecValueData as String : data]
    


        SecItemDelete(addQuery as CFDictionary)
        SecItemAdd(addQuery as CFDictionary, nil)
    }

    func load(key: String) -> String? {
        
        let getQuery: [String : Any] = [kSecClass as String : kSecClassGenericPassword,
                                        kSecAttrAccount as String : key,
                                        kSecReturnData as String : kCFBooleanTrue!,
                                        kSecMatchLimit as String : kSecMatchLimitOne]

        var dataTypeRef: AnyObject? = nil

        let status = SecItemCopyMatching(getQuery as CFDictionary, &dataTypeRef)

        guard status != errSecItemNotFound else {
            return nil
        }
            
        guard status == errSecSuccess else {
            return nil
        }
        
        guard let value = dataTypeRef as? Data else {
            return nil
        }

        return String(data: value, encoding: .utf8)
    }
}
