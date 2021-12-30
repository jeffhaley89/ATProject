//
//  Restaurants.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/16/21.
//

import Foundation

struct Restaurants: Codable {
    let results: [Restaurant]
}

struct Restaurant: Codable {
    let geometry: Geometry?
    let name: String?
    let openingHours: OpeningHours?
    let photos: [Photo]?
    let placeID: String?
    let priceLevel: Int?
    let rating: Double?
    let userRatingsTotal: Int?

    enum CodingKeys: String, CodingKey {
        case geometry
        case name
        case openingHours = "opening_hours"
        case photos
        case placeID = "place_id"
        case priceLevel = "price_level"
        case rating
        case userRatingsTotal = "user_ratings_total"
    }
}

struct Geometry: Codable {
    let location: Location?
}

struct Location: Codable {
    let lat: Double?
    let lng: Double?
}

struct OpeningHours: Codable {
    let openNow: Bool?

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

struct Photo: Codable {
    let photoReference: String?

    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}
