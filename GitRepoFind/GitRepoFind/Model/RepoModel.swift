//
//  RepoModel.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation

struct RepoModel: Codable {
    var id: Int?
    var name: String?
    var full_name: String?
    var owner: OwnerModel?
    var description: String
    var forks: Int?
    var watchers: Int?
}
