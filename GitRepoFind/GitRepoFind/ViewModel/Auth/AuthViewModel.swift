//
//  AuthViewModel.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 22/09/2021.
//

import Foundation
import RxSwift

struct AuthViewModel {
    
    private let authUseCase: AuthUseCaseProtocol
    
    init(authUseCase: AuthUseCaseProtocol = AuthUseCase()) {
        self.authUseCase = authUseCase
    }
    
    func authenticate() -> Observable<String> {
        return authUseCase.authenticate()
    }
}
