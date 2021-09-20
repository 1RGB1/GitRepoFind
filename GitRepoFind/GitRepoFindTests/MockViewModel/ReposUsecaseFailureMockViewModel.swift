//
//  ReposUseCaseFailureMockViewModel.swift
//  GitRepoFindTests
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import Foundation
import RxSwift
@testable import GitRepoFind

class ReposUseCaseFailureMockViewModel: ReposUseCaseProtocol {
    func findGitReposBySearchQuery(_ query: String) -> Observable<[RepoModel]> {
        let error = NetworkError(errorMsg: ErrorType.genericError.rawValue)
        return Observable<[RepoModel]>.error(error)
    }
}
