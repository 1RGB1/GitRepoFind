//
//  ReposRouter.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation
import Alamofire

let SEARCH_REPOS_PATH = "search/repositories"

enum ReposRouter: ApiBaseRouter {
    case findGitRepos(String)
}

extension ReposRouter {
    
    var path: String {
        return SEARCH_REPOS_PATH
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .findGitRepos(let query):
            return ["q" : query]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .findGitRepos:
            return .get
        }
    }
}
