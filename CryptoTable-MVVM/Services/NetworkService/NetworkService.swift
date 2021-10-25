//
//  Network.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import Foundation
import Combine

enum NetworkServiceError: Error {
    case internalError
    case networkError(Error)
}

protocol NetworkService {
    func getRequest<T: Decodable>(url: URL) -> AnyPublisher<T, NetworkServiceError>
}


class NetworkServiceImpl: NetworkService {
    
    func getRequest<T>(url: URL) -> AnyPublisher<T, NetworkServiceError> where T : Decodable {
        
            return URLSession
                .shared
                .dataTaskPublisher(for: url)
                .tryMap { (data: Data, response: URLResponse) -> T in
                    
//                    let cache = try self.storage.get(key: "cacheData")
//                    print("cache - \(cache)")
//                    if cache.isEmpty {
//                        self.storage.set(data: data, key: "cacheData")
//                        return try JSONDecoder().decode(T.self, from: data)
//                    } else {
                        try JSONDecoder().decode(T.self, from: data)
//                    }
                }.mapError {
                    .networkError($0)
                }
                .eraseToAnyPublisher()
    }
}
