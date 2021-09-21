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
    
    private init() {}
    
    static let shared: NetworkConfigInfo = {
        return NetworkConfigInfo()
    } ()
    
    func getParam(withType type: NetworkConfigInfoType) -> String {
        
        let configInfo = getConfigInfo()
        var param = ""
        
        switch type {
        case .baseURL:
            param = getConfigValue(configInfo: configInfo, forKey: "BASE_URL")
        case .apiType:
            param = getConfigValue(configInfo: configInfo, forKey: "IS_MOCK")
        }
        
        return param
    }
    
    fileprivate func getConfigInfo() -> [String : Any]? {
        return Bundle.main.infoDictionary
    }
    
    fileprivate func getConfigValue(configInfo: [String : Any]?, forKey key: String) -> String {
        return (configInfo?[key] as? String) ?? ""
    }
}
