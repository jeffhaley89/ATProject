//
//  NetworkManager.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/16/21.
//

import UIKit

enum NetworkManagerError: Error {
    case unexpectedResponse
    case unknown(Error)
    case deserializationError(Error)
}

protocol NetworkManager: AnyObject {
    func get<T: Decodable>(_ url: URL, objectType: T.Type, completion: @escaping (Result<T, NetworkManagerError>) -> ())
    func getImage(_ url: URL, completion: @escaping (Result<UIImage, NetworkManagerError>) -> ())
}
    
class DefaultNetworkManager: NetworkManager {
    func get<T: Decodable>(_ url: URL, objectType: T.Type, completion: @escaping (Result<T, NetworkManagerError>) -> ()) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.unexpectedResponse))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(.success(decodedObject))
            } catch let error {
                completion(.failure(.deserializationError(error as! DecodingError)))
            }
        })

        task.resume()
    }
    
    func getImage(_ url: URL, completion: @escaping (Result<UIImage, NetworkManagerError>) -> ()) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.unexpectedResponse))
                return
            }

            if let image = UIImage(data: data, scale: 1.0) {
                completion(.success(image))
            } else {
                completion(.failure(.deserializationError(error as! DecodingError)))
            }
        })

        task.resume()
    }
}
