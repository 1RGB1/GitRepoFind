//
//  AuthServiceHandle.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 22/09/2021.
//

import Foundation
import RxSwift
import FirebaseAuth

class AuthServiceHandle {
    
    var provider = OAuthProvider(providerID: "github.com")
    var authSuccessObserver = PublishSubject<String>()
    private init() {}
    static let shared: AuthServiceHandle = {
        return AuthServiceHandle()
    } ()
    
    func authenticate() {
        provider.scopes = ["user:email", "repo", "read:org"]
        provider.getCredentialWith(nil) { [weak self] credential, error in
            if error != nil {
                print(error!.localizedDescription)
                self?.authSuccessObserver.onError(error!)
            } else {
                if credential != nil {
                    Auth.auth().signIn(with: credential!) { [weak self] authResult, error in
                        if error != nil {
                            print(error!.localizedDescription)
                            self?.authSuccessObserver.onError(error!)
                        } else {
                            if let auth = authResult {
                                guard let oauthCredential = auth.credential as? OAuthCredential,
                                      let accessToken = oauthCredential.accessToken
                                else {
                                    self?.authSuccessObserver.onNext(ErrorType.authFailed.rawValue)
                                    return
                                }
                                self?.authSuccessObserver.onNext(accessToken)
                            } else {
                                self?.authSuccessObserver.onNext(ErrorType.authFailed.rawValue)
                            }
                        }
                    }
                }
            }
        }
    }
}
