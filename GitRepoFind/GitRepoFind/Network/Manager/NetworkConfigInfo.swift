//
//  NetworkConfigInfo.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 21/09/2021.
//

import Foundation

enum NetworkConfigInfoType: Int {
    case baseURL
    case apiType
    case clientID
    case clientSecret
}

class NetworkConfigInfo {
    
    private init() {}
    
    static let shared: NetworkConfigInfo = {
        return NetworkConfigInfo()
    } ()
    
    func getParam(withType type: NetworkConfigInfoType) -> String {
        
        var param = ""
        
        switch type {
        case .baseURL:
            param = getConfigValueForKey("BASE_URL")
        case .apiType:
            param = getConfigValueForKey("IS_MOCK")
        case .clientID:
            param = getConfigValueForKey("CLIENT_ID")
        case .clientSecret:
            param = getConfigValueForKey("CLIENT_SECRET")
        }
        
        return param
    }
    
    fileprivate func getConfigValueForKey(_ key: String) -> String {
        let configInfo = Bundle.main.infoDictionary
        return (configInfo?[key] as? String) ?? ""
    }
}
