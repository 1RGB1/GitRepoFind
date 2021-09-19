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
struct NetworkManager {
    
    private let scheduler: ConcurrentDispatchQueueScheduler
    private init(scheduler: ConcurrentDispatchQueueScheduler) {
        self.scheduler = scheduler
    }
    
    static let shared: NetworkManager = {
        let instance = NetworkManager(scheduler: ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: .background, relativePriority: 1)))
        return instance
    } ()
    
    /// To load data from api in a generic way
    /// - Parameters:
    ///   - request:    request conforming base router combined with all required attributes for calling the api
    ///   - completion: completion block with model or with the network error
    func getData<T: BaseModel>(request: URLRequestConvertible) -> Observable<Result<T, NetworkError>> {
        return RxAlamofire
            .request(request)
            .observe(on: scheduler)
            .responseData()
            .flatMap { (response, data) -> Observable<Result<T, NetworkError>>  in
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
                        if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            //let message = dictionary[Constants.MESSAGE] as? String ?? "Error processing request!"
                            let message = ErrorType.requestFailed.rawValue
                            let networkError = NetworkError(errorMsg: message)
                            return Observable<Result<T, NetworkError>>.just(.failure(networkError))
                        }
                    } catch let errorModel {
                        let networkError = NetworkError(errorMsg: errorModel.localizedDescription)
                        return Observable<Result<T, NetworkError>>.just(.failure(networkError))
                    }
                }
                
                let networkError = NetworkError(errorMsg: ErrorType.genericError.rawValue)
                return Observable<Result<T, NetworkError>>.just(.failure(networkError))
            }
    }
}
