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
    
    private var useCase: ReposUseCaseProtocol
    
    init(useCase: ReposUseCaseProtocol = ReposUseCase()) {
        self.useCase = useCase
    }
    
    func findGitReposBySearchQuery(_ query: String) -> Observable<[BaseCellViewModel]> {
        return useCase.findGitReposBySearchQuery(query)
            .flatMap { [weak self] repos -> Observable<[BaseCellViewModel]> in
                guard let self = self else { return Observable<[BaseCellViewModel]>.just([]) }
                return self.prepCellsViewModelsWithRepos(repos)
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
