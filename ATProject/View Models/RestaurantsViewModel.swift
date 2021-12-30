//
//  RestaurantsViewModel.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/15/21.
//

import CoreData
import MapKit

protocol RestaurantsViewModel: AnyObject {
    var infoViewsContent: [RestaurantInfoView.Content] { get }

    func getRestaurantsViewContent(query: String?, completion: @escaping (Result<(), NetworkManagerError>) -> ())
    func getSelectedRestaurantContent(with coordinate: CLLocationCoordinate2D) -> RestaurantInfoView.Content?
    func saveFavoritedRestaurant(id: String)
    func removeFavoritedRestaurant(id: String)
}

class DefaultRestaurantsViewModel: RestaurantsViewModel {
    var infoViewsContent = [RestaurantInfoView.Content]()
    var restaurantsService: RestaurantsService

    init(restaurantsService: RestaurantsService = DefaultRestaurantsService()) {
        self.restaurantsService = restaurantsService
    }

    func getRestaurantsViewContent(query: String?, completion: @escaping (Result<(), NetworkManagerError>) -> ()) {
        restaurantsService.getOpenRestaurants(with: query, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(restaurants):
                    self.infoViewsContent = self.mapToInfoViewsContent(with: restaurants.results)
                    completion(.success(()))

                case let .failure(error):
                    completion(.failure(error))
                }
            }
        })
    }
    
    func mapToInfoViewsContent(with restaurants: [Restaurant]) -> [RestaurantInfoView.Content] {
        restaurants.map {
            RestaurantInfoView.Content(
                name: $0.name,
                ratingImage: getRatingStarImage(rating: $0.rating),
                totalRatings: "(\($0.userRatingsTotal ?? 0))",
                priceLevel: getPriceLevelSymbols(priceLevel: $0.priceLevel),
                openClosed: getOpenClosedText(isOpen: $0.openingHours?.openNow),
                restaurantPhotos: $0.photos,
                heartState: getHeartState(with: $0.placeID),
                placeID: $0.placeID,
                annotation: getMapAnnotation(
                    lat: $0.geometry?.location?.lat,
                    lng: $0.geometry?.location?.lng))
        }
    }
    
    func getRatingStarImage(rating: Double?) -> UIImage? {
        guard let rating = rating else { return nil }
        switch rating {
        case 0..<1.5: return UIImage(image: .ratingStarOne)
        case 1.5..<2.5: return UIImage(image: .ratingStarTwo)
        case 2.5..<3.5: return UIImage(image: .ratingStarThree)
        case 3.5..<4.5: return UIImage(image: .ratingStarFour)
        default: return UIImage(image: .ratingStarFive)
        }
    }
    
    func getPriceLevelSymbols(priceLevel: Int?) -> String? {
        guard let priceLevel = priceLevel else {
            return nil
        }
        
        switch priceLevel {
        case 0: return "FREE •"
        case 1: return "$ •"
        case 2: return "$$ •"
        case 3: return "$$$ •"
        case 4: return "$$$$ •"
        default: return nil
        }
    }
    
    func getOpenClosedText(isOpen: Bool?) -> OpenClosed? {
        guard let isOpen = isOpen else { return nil }
        return OpenClosed(isOpen: isOpen)
    }
    
    func getHeartState(with placeID: String?) -> HeartState {
        isRestaurantFavorited(placeID: placeID) ? .filled : .empty
    }
    
    func isRestaurantFavorited(placeID: String?) -> Bool {
        guard let id = placeID else { return false }
        let favorites = CoreDataManager.shared.getAllFavoritedRestaurants()
        return favorites.contains(where: { $0.value(forKeyPath: CoreDataManager.Attribute.restaurantID.rawValue) as? String == id })
    }
    
    func saveFavoritedRestaurant(id: String) {
        CoreDataManager.shared.saveFavoritedRestaurant(id: id) { success in
            guard success else { return }
            toggleContentHeartState(with: id, to: .filled)
        }
    }
    
    func removeFavoritedRestaurant(id: String) {
        CoreDataManager.shared.removeFavoritedRestaurant(id: id) { success in
            guard success else { return }
            toggleContentHeartState(with: id, to: .empty)
        }
    }
    
    func toggleContentHeartState(with id: String, to heartState: HeartState) {
        guard let index = infoViewsContent.firstIndex(where: { $0.placeID == id }) else { return }
        infoViewsContent[index].heartState = heartState
    }
    
    func getMapAnnotation(lat: Double?, lng: Double?) -> MKPointAnnotation? {
        guard let latitude = lat, let longitude = lng else { return nil }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return annotation
    }
    
    func getSelectedRestaurantContent(with coordinate: CLLocationCoordinate2D) -> RestaurantInfoView.Content? {
        infoViewsContent.first(where: {
            $0.annotation?.coordinate.latitude == coordinate.latitude &&
            $0.annotation?.coordinate.longitude == coordinate.longitude
        })
    }
}

