//
//  ReposModel.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation

struct ReposModel: BaseModel {
    var total_count: Int?
    var incomplete_results: Int?
    var items: [RepoModel]?
}
