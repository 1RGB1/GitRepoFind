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
}

class NetworkConfigInfo {
    
    static func getParam(withType type: NetworkConfigInfoType) -> String {
        
        let configInfo = getConfigInfo()
        
        switch type {
        case .baseURL:
            return getConfigValue(configInfo: configInfo, forKey: "BASE_URL")
        case .apiType:
            return getConfigValue(configInfo: configInfo, forKey: "IS_MOCK")
        }
    }
    
    static fileprivate func getConfigInfo() -> [String : Any]? {
        return Bundle.main.infoDictionary
    }
    
    static fileprivate func getConfigValue(configInfo: [String : Any]?, forKey key: String) -> String {
        return (configInfo?[key] as? String) ?? ""
    }
}
