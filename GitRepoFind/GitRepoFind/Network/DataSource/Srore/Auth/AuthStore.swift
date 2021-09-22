//
//  AuthStore.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 22/09/2021.
//

import Foundation
import RxSwift

protocol AuthStoreProtocol {
    func authenticate() -> Observable<Result<AuthModel, NetworkError>>
}

struct AuthStore: AuthStoreProtocol {
    
    /// To authenticate with github
    /// - Returns: Observable containing model in case of success and network error in case of failure
    func authenticate() -> Observable<Result<AuthModel, NetworkError>> {
        return NetworkManager.shared.authenticate()
    }
}
