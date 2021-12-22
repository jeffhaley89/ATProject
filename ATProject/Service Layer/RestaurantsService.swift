//
//  RestaurantsService.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/16/21.
//

import Foundation

protocol RestaurantsService: AnyObject {
    func getOpenRestaurants(with searchString: String?, completion: @escaping (Result<Restaurants, NetworkManagerError>) -> ())
}

class DefaultRestaurantsService: RestaurantsService {
    let manager: NetworkManager

    init(manager: NetworkManager = DefaultNetworkManager()) {
        self.manager = manager
    }
    
    func getOpenRestaurants(with query: String?, completion: @escaping (Result<Restaurants, NetworkManagerError>) -> ()) {
        guard let url = createGetOpenRestaurantsURL(with: query) else { return }
        manager.get(url, objectType: Restaurants.self) { result in
            // TODO: switch on result type to return specific/relevant errors from this layer
//            switch result {
//            case let .success(restaurants):
//
//            case let .failure(error):
//
//            }
            completion(result)
        }
    }

    func createGetOpenRestaurantsURL(with query: String?) -> URL? {
        var urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyDue_S6t9ybh_NqaeOJDkr1KC9a2ycUYuE&type=restaurant"
        if let query = query,
            let encodedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            urlString.append("&query=\(encodedString)")
        }

        return URL(string: urlString)
    }
}
