//
//  BaseModel.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation

struct ErrorModel: BaseModel {
    var message: String?
    var errors: [String : String]?
    var documentation_url: String?
}
