//
//  ReposModel.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation

struct ReposModel: BaseModel {
    var total_countl: Int?
    var incomplete_results: Bool?
    var items: [RepoModel]?
}
