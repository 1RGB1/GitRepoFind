//
//  ReposFindViewModelTests.swift
//  GitRepoFindTests
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import XCTest
import RxSwift
@testable import GitRepoFind

class ReposFindViewModelTests: XCTestCase {
    
    var successMockUseCase: ReposUseCaseProtocol = ReposUseCaseSuccessMockViewModel()
    var failMockUseCase: ReposUseCaseProtocol = ReposUseCaseFailureMockViewModel()
    var viewModel: ReposFindViewModel?
    let disposeBag = DisposeBag()

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func test_SuccessMock() {
        
        viewModel = ReposFindViewModel(useCase: successMockUseCase)
        XCTAssertNotNil(viewModel)
        
        viewModel!.findGitReposBySearchQuery("swift").subscribe { cellsViewModels in
            let _ = cellsViewModels.map { models in
                for model in models {
                    XCTAssertNotNil(model as? RepoCellViewModel)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func test_FailMock() {
        
        viewModel = ReposFindViewModel(useCase: failMockUseCase)
        XCTAssertNotNil(viewModel)
        
        viewModel!.findGitReposBySearchQuery("").subscribe { cellsViewModels in
        } onError: {
            let error = $0 as? NetworkError
            XCTAssertTrue(error?.errorMsg == ErrorType.genericError.rawValue)
        }.disposed(by: disposeBag)
    }
}
