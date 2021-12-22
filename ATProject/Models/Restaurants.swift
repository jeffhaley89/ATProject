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
//    let formattedAddress: String
    let geometry: Geometry?
    let name: String?
    let openingHours: OpeningHours?
    let photos: [Photo]?
    let placeID: String?
    let priceLevel: Int? // $$$
    let rating: Double? // 1 to 5
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
    let photoReference: String? // use Place Photo API: https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=photo_reference&key=YOUR_API_KEY

    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}
