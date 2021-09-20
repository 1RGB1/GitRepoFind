//
//  MockHandler.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 18/09/2021.
//

import Foundation

struct MockHandler<T: Codable> {
    func getMockModel(jsonFileName: String, completion: @escaping (T) -> ()) {
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                completion(model)
            } catch {
                print(error)
            }
        }
    }
}
