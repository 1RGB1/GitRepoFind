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
}
