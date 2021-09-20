//
//  ReposUseCaseSuccessMockViewModel.swift
//  GitRepoFindTests
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import Foundation
import RxSwift
@testable import GitRepoFind

class ReposUseCaseSuccessMockViewModel: ReposUseCaseProtocol {
    func findGitReposBySearchQuery(_ query: String) -> Observable<[RepoModel]> {
        
        var observable = Observable<[RepoModel]>.just([])
        
        MockHandler().getMockModel(jsonFileName: "ReposMockModel") { (model: ReposModel) in
            if let items = model.items {
                observable = Observable<[RepoModel]>.just(items)
            }
        }
        
        return observable
    }
}
