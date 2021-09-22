//
//  StringExtension.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 21/09/2021.
//

import Foundation

extension String {
    var boolValue: Bool {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0", "":
            return false
        default:
            return false
        }
    }
    
    func getAttributeValue(_ param: String) -> String {
        
        let urlComponents = self.components(separatedBy: "&")
        let result = ""
        
        for keyValuePair in urlComponents {
            let pairComponents = keyValuePair.components(separatedBy: "=")
            guard var key = pairComponents.first?.removingPercentEncoding else { return result }
            let value = pairComponents.last?.removingPercentEncoding
            
            if key.contains("?") {
                let keyComponentArray = key.components(separatedBy: "?")
                key = keyComponentArray.last ?? ""
            }
            
            if key == param {
                return value ?? ""
            }
        }
        
        return result
    }
}
