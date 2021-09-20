//
//  NetworkManager.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 19/09/2021.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

/// Singletone manager to handle all api calls
class NetworkManager {
    
    private init() {}
    
    static let shared: NetworkManager = {
        return NetworkManager()
    } ()
    
    /// To load data from api in a generic way
    /// - Parameters:
    ///   - request:    request conforming base router combined with all required attributes for calling the api
    ///   - completion: completion block with model or with the network error
    /// - Returns: Observable containing T in case of success and network error in case of failure
    func getData<T: BaseModel>(request: URLRequestConvertible) -> Observable<Result<T, NetworkError>> {
        return RxAlamofire
            .request(request)
            .debug()
            .observe(on: MainScheduler.instance)
            .responseData()
            .flatMap({ (response, data) -> Observable<Result<T, NetworkError>> in
                
                print(data.parseToJSONString() ?? [:])
                
                if 200...300 ~= response.statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(T.self, from: data)

                        if let _ = model as? ErrorModel {
                            let networkError = NetworkError(errorMsg: ErrorType.parsingFaild.rawValue)
                            return Observable<Result<T, NetworkError>>.just(.failure(networkError))
                        } else {
                            return Observable<Result<T, NetworkError>>.just(.success(model))
                        }
                    } catch let errorModel {
                        let networkError = NetworkError(errorMsg: errorModel.localizedDescription)
                        return Observable<Result<T, NetworkError>>.just(.failure(networkError))
                    }
                } else {
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(ErrorModel.self, from: data)
                        let networkError = NetworkError(errorMsg: model.message ?? ErrorType.genericError.rawValue)
                        return Observable<Result<T, NetworkError>>.just(.failure(networkError))
                    } catch let errorModel {
                        let networkError = NetworkError(errorMsg: errorModel.localizedDescription)
                        return Observable<Result<T, NetworkError>>.just(.failure(networkError))
                    }
                }
            })
    }
}
