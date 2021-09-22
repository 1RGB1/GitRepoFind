//
//  AuthUseCase.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 22/09/2021.
//

import Foundation
import RxSwift


protocol AuthUseCaseProtocol {
    func authenticate() -> Observable<String>
}

struct AuthUseCase: AuthUseCaseProtocol {
    
    let authStore: AuthStoreProtocol
    
    init(authStore: AuthStoreProtocol = AuthStore()) {
        self.authStore = authStore
    }
    
    /// To authenticate with github
    /// - Returns: Observable containing auth model
    func authenticate() -> Observable<String> {
        let observable = authStore.authenticate()
        return mapToTokenString(observable)
    }
    
    /// To map observable to observable
    /// - Parameters:
    ///   - observable:  Observable containing model in case of success and network error in case of failure
    /// - Returns: Observable containing array of repo model
    fileprivate func mapToTokenString(_ observable: Observable<Result<AuthModel, NetworkError>>) -> Observable<String> {
        observable
            .flatMap { (result: Result<AuthModel, NetworkError>) -> Observable<String> in
                switch result {
                case .success(let model):
                    return Observable<String>.just(model.token)
                case .failure(let error):
                    return Observable<String>.error(error)
                }
            }
    }
}
