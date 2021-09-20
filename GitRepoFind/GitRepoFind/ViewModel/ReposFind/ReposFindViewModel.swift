//
//  ReposFindViewModel.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import Foundation
import UIKit
import RxSwift

class ReposFindViewModel {
    
    var usecase: ReposUseCaseProtocol
    
    init(usecase: ReposUseCaseProtocol = ReposUseCase()) {
        self.usecase = usecase
    }
    
    func findGitReposBySearchQuery(_ query: String) -> Observable<[BaseCellViewModel]> {
        return usecase.findGitReposBySearchQuery(query)
            .flatMap { [weak self] repos in
                return self?.prepCellsViewModelsWithRepos(repos) ?? Observable<[BaseCellViewModel]>.just([])
            }
    }
    
    fileprivate func prepCellsViewModelsWithRepos(_ repos: [RepoModel]) -> Observable<[BaseCellViewModel]> {
        
        var cellsViewModels = [BaseCellViewModel]()
        
        let reposViewModels = repos.map {
            RepoCellViewModel(repoModel: $0)
        }
        
        cellsViewModels.append(contentsOf: reposViewModels)
        
        return Observable<[BaseCellViewModel]>.just(cellsViewModels)
    }
 }
