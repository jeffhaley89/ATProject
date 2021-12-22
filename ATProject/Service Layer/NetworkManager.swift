//
//  NetworkManager.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/16/21.
//

import Foundation

enum NetworkManagerError: Error {
    case unexpectedResponse
    case unknown(Error)
    case deserializationError(Error)
}

protocol NetworkManager: AnyObject {
    func get<T: Decodable>(_ url: URL, objectType: T.Type, completionHandler: @escaping (Result<T, NetworkManagerError>) -> ())
}
    
class DefaultNetworkManager: NetworkManager {
    func get<T: Decodable>(_ url: URL, objectType: T.Type, completionHandler: @escaping (Result<T, NetworkManagerError>) -> ()) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completionHandler(Result.failure(.unknown(error)))
                return
            }

            guard let data = data else {
                completionHandler(Result.failure(.unexpectedResponse))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completionHandler(Result.success(decodedObject))
            } catch let error {
                completionHandler(Result.failure(.deserializationError(error as! DecodingError)))
            }
        })

        task.resume()
    }
}
