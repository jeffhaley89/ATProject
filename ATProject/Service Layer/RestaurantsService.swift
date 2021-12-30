//
//  RestaurantsService.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/16/21.
//

import UIKit

protocol RestaurantsService: AnyObject {
    func getOpenRestaurants(with searchString: String?, completion: @escaping (Result<Restaurants, NetworkManagerError>) -> ())
    func getPlacePhoto(with reference: String, completion: @escaping (Result<UIImage, NetworkManagerError>) -> ())
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
    
    func getPlacePhoto(with reference: String, completion: @escaping (Result<UIImage, NetworkManagerError>) -> ()) {
        guard let url = createGetPlacePhotoURL(with: reference) else { return }
        manager.getImage(url) { result in
            // TODO: switch on result type to return specific/relevant errors from this layer
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

    func createGetPlacePhotoURL(with reference: String) -> URL? {
        URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(reference)&key=AIzaSyDue_S6t9ybh_NqaeOJDkr1KC9a2ycUYuE")
    }
}
