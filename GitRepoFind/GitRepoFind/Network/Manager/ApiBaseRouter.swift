//
//  ApiBaseRouter.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation
import Alamofire

/// A type that have all required attributes to make an api call
public protocol ApiBaseRouter: URLRequestConvertible {
    var path: String {get}
    var body: [String : Any]? {get}
    var parameters: [String : Any]? {get}
    var method: HTTPMethod {get}
    var headers: HTTPHeaders {get}
}

extension ApiBaseRouter {
    
    /// API's path to appened to base url
    var path: String {
        return ""
    }
    
    /// API's body to send it with api call
    var body: [String : Any]? {
        return nil
    }
    
    /// API's parameters to send it with api call
    var parameters: [String : Any]? {
        return nil
    }
    
    /// API's method to define api call
    var method: HTTPMethod {
        return .get
    }
    
    /// API's headers to send it with api call
    var headers: HTTPHeaders {
        return [:]
    }
    
    /// To combine all attributes in one url request
    func asURLRequest() throws -> URLRequest {
        let baseURL = NetworkConfigInfo.shared.getParam(withType: .baseURL)
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers.dictionary
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
