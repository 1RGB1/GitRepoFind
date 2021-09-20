//
//  DataExtension.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import Foundation

extension Data {
    
    func parseToJSONString() -> [String : Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String : Any]
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        return nil
    }
}
