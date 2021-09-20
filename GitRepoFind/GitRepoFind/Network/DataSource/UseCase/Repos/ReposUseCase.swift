//
//  ReposUseCase.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation
import RxSwift

protocol ReposUseCaseProtocol {
    func findGitReposPage(_ page: Int, bySearchQuery query: String) -> Observable<[RepoModel]>
}

struct ReposUseCase: ReposUseCaseProtocol {
    
    var reposStore: ReposStoreProtocol
    
    init(reposStore: ReposStoreProtocol = ReposStore()) {
        self.reposStore = reposStore
    }
    
    /// To find git repos
    /// - Parameters:
    ///   - page:  for pagination feature to load page by page
    ///   - query: search query to find all repos related to it
    /// - Returns: Observable containing model in case of success and network error in case of failure
    func findGitReposPage(_ page: Int, bySearchQuery query: String) -> Observable<[RepoModel]> {
        let observable = reposStore.findGitReposPage(page, bySearchQuery: query)
        return mapToRepos(observable)
    }
    
    private func mapToRepos(_ observable: Observable<Result<ReposModel, NetworkError>>) -> Observable<[RepoModel]> {
        observable.flatMap { (result: Result<ReposModel, NetworkError>) -> Observable<[RepoModel]> in
            switch result {
            case .success(let model):
                return Observable<[RepoModel]>.just(model.items ?? [RepoModel]())
            case .failure(let error):
                return Observable<[RepoModel]>.error(error)
            }
        }
    }
}