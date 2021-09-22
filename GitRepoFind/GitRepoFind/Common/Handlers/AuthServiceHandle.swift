//
//  AuthServiceHandle.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 22/09/2021.
//

import Foundation
import AuthenticationServices
import SafariServices
import RxSwift
import FirebaseAuth

class AuthServiceHandle {
    
//    private var authSession: SFAuthenticationSession?
    var provider = OAuthProvider(providerID: "github.com")
    var authSuccessObserver = PublishSubject<String>()
    private init() {}
    static let shared: AuthServiceHandle = {
        return AuthServiceHandle()
    } ()
 
//    fileprivate func getAuthenticateURL() -> URL {
//
//        var urlComponent = URLComponents(string: "https://github.com/login/oauth/authorize")!
//        var queryItems =  urlComponent.queryItems ?? []
//
//        let clientSecret = NetworkConfigInfo.shared.getParam(withType: .clientSecret)
//        let clientID = NetworkConfigInfo.shared.getParam(withType: .clientID)
//        queryItems.append(URLQueryItem(name: "client_id", value: clientID))
//        queryItems.append(URLQueryItem(name: "client_secret", value: clientSecret))
//        queryItems.append(URLQueryItem(name: "redirect_uri", value: "GitRepoFind://login"))
//
//        urlComponent.queryItems = queryItems
//
//        return urlComponent.url!
//    }
//
//    func authenticate() {
//
//        authSession?.cancel()
//
//        let url = getAuthenticateURL()
//
//        authSession = SFAuthenticationSession(url: url, callbackURLScheme: nil, completionHandler: { [weak self] ( url, error) in
//            let token = url?.absoluteString.getAttributeValue("code") ?? ""
//            self?.authSuccessObserver.onNext((token))
//        })
//
//        authSession?.start()
//    }
    
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
