//
//  ReposStore.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation
import RxSwift

protocol ReposStoreProtocol {
    func findGitReposPage(_ page: Int, bySearchQuery query: String) -> Observable<Result<ReposModel, NetworkError>>
}

struct ReposStore: ReposStoreProtocol {
    
    /// To find git repos
    /// - Parameters:
    ///   - page:  for pagination feature to load page by page
    ///   - query: search query to find all repos related to it
    /// - Returns: Observable containing model in case of success and network error in case of failure
    func findGitReposPage(_ page: Int, bySearchQuery query: String) -> Observable<Result<ReposModel, NetworkError>> {
        let reposRouter = ReposRouter.findGitRepos(query, page)
        return NetworkManager.shared.getData(request: reposRouter)
    }
}
