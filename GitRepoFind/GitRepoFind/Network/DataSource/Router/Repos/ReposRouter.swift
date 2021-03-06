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
            return ["accept" : "application/vnd.github.v3+json",
                    "q" : query]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .findGitRepos:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .findGitRepos:
            var headers: [String : String] = ["token_type" : "bearer"]
            let accessToken = getAccessToken()
            
            if !accessToken.isEmpty {
                headers["Authorization"] = "token \(accessToken)"
            }
            
            print(headers)
            return HTTPHeaders(headers)
        }
    }
    
    func getAccessToken() -> String {
        return KeyChain.shared.load(key: AUTH_TOKEN) ?? ""
    }
}
