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
    
    private let scheduler: ConcurrentDispatchQueueScheduler
    static let shared: NetworkManager = {
        let instance = NetworkManager(scheduler: ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: .background, relativePriority: 1)))
        return instance
    } ()
    
    /// To inistantiate network singleton object
    /// - Parameters:
    ///   - scheduler: dispatch queue to run on it
    /// - Returns: Observable containing T in case of success and network error in case of failure
    private init(scheduler: ConcurrentDispatchQueueScheduler) {
        self.scheduler = scheduler
    }
    
    /// To load data from api in a generic way
    /// - Parameters:
    ///   - request: request conforming base router combined with all required attributes for calling the api
    /// - Returns: Observable containing T in case of success and network error in case of failure
    func getData<T: BaseModel>(request: URLRequestConvertible) -> Observable<Result<T, NetworkError>> {
        
        let isMock = NetworkConfigInfo.shared.getParam(withType: .apiType).boolValue
        
        if isMock {
            if let model: T = MockHandler().getMockModel(jsonFileName: "ReposMockModel") {
                return Observable<Result<T, NetworkError>>.just(.success(model))
            }
            return Observable<Result<T, NetworkError>>.just(.failure(NetworkError(errorMsg: ErrorType.parsingFaild.rawValue)))
        } else {
            return RxAlamofire
                .request(request)
                .debug()
                .observe(on: scheduler)
                .responseData()
                .flatMap({ [weak self] (response, data) -> Observable<Result<T, NetworkError>> in
                    return
                        self?.parseData(response, data) ??
                        Observable<Result<T, NetworkError>>.just(.failure(NetworkError(errorMsg: ErrorType.genericError.rawValue)))
                })
        }
    }
    
    /// To parse response and data into observable
    /// - Parameters:
    ///   - response: response of api call
    ///   - data:     returned data from api call in data object
    /// - Returns: Observable containing T in case of success and network error in case of failure
    fileprivate func parseData<T: BaseModel>(_ response: HTTPURLResponse, _ data: Data) -> Observable<Result<T, NetworkError>> {
        
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
    }
}
