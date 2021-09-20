//
//  ReposFindViewModel.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import Foundation
import UIKit
import RxSwift

protocol ReposFindViewModelDelegate: AnyObject {
    func showErrorWithMessage(_ message: String)
}

class ReposFindViewModel {
    
    var usecase: ReposUseCaseProtocol
    
    let disposeBag = DisposeBag()
    let cellsViewModelsObserver: PublishSubject<[BaseCellViewModel]> = .init()
    var cellsViewModels = [BaseCellViewModel]()
    var currentPage = 1
    var query = "swift"
    weak var delegate: ReposFindViewModelDelegate?
    
    init(usecase: ReposUseCaseProtocol = ReposUseCase()) {
        self.usecase = usecase
    }
    
    func findReposInPage(_ page: Int, bySearchQuery query: String) {
        usecase.findGitReposPage(page, bySearchQuery: query).subscribe { [weak self] repos in
            self?.prepCellsViewModelsWithRepos(repos)
            self?.cellsViewModelsObserver.onNext(self?.cellsViewModels ?? [BaseCellViewModel]())
        } onError: { [weak self] in
            self?.delegate?.showErrorWithMessage($0.localizedDescription)
        }.disposed(by: disposeBag)
    }
    
    fileprivate func prepCellsViewModelsWithRepos(_ repos: [RepoModel]) {
        
        if currentPage == 1 {
            cellsViewModels.removeAll()
        }
        
        let reposViewModels = repos.map {
            RepoCellViewModel(repoModel: $0)
        }
        
        cellsViewModels.append(contentsOf: reposViewModels)
    }
 }
