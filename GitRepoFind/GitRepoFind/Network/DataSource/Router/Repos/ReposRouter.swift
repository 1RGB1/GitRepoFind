//
//  ReposRouter.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation
import Alamofire

enum ReposRouter: ApiBaseRouter {
    case findGitRepos(String, Int)
}

extension ReposRouter {
    
    var path: String {
        return NetworkConstants.searchReposPath
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .findGitRepos(let query, let page):
            return ["q" : query,
                    "page" : page]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .findGitRepos:
            return .get
        }
    }
}
