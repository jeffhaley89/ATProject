//
//  RestaurantsViewModel.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/15/21.
//

import CoreData
import MapKit

protocol RestaurantsViewModel: AnyObject {
    var listViewContent: RestaurantsTableView.Content { get }
    var mapViewContent: RestaurantsMapView.Content { get }

    func getRestaurantsViewContent(query: String?, completion: @escaping (Result<(), NetworkManagerError>) -> ())
    func getSelectedRestaurantContent(with coordinate: CLLocationCoordinate2D) -> RestaurantInfoView.Content?
    func saveFavoritedRestaurant(id: String)
    func removeFavoritedRestaurant(id: String)
}

class DefaultRestaurantsViewModel: RestaurantsViewModel {
    var listViewContent = RestaurantsTableView.Content(cellsContent: [])
    var mapViewContent = RestaurantsMapView.Content(annotations: [])
    var restaurantsService: RestaurantsService
    
    lazy var oneStarImage = UIImage(named: "RatingStar1")
    lazy var twoStarImage = UIImage(named: "RatingStar2")
    lazy var threeStarImage = UIImage(named: "RatingStar3")
    lazy var fourStarImage = UIImage(named: "RatingStar4")
    lazy var fiveStarImage = UIImage(named: "RatingStar5")
    
    init(restaurantsService: RestaurantsService = DefaultRestaurantsService()) {
        self.restaurantsService = restaurantsService
    }

    func getRestaurantsViewContent(query: String?, completion: @escaping (Result<(), NetworkManagerError>) -> ()) {
        restaurantsService.getOpenRestaurants(with: query, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(restaurants):
                let infoViewContent = self.mapToInfoViewContent(with: restaurants.results)
                self.listViewContent = RestaurantsTableView.Content(cellsContent: infoViewContent)
                self.mapViewContent = RestaurantsMapView.Content(annotations: infoViewContent.map { $0.annotation })
                completion(.success(()))

            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func mapToInfoViewContent(with restaurants: [Restaurant]) -> [RestaurantInfoView.Content]{
        restaurants.map {
            RestaurantInfoView.Content(
                name: $0.name,
                ratingImage: self.getRatingStarImage(rating: $0.rating),
                totalRatings: "(\($0.userRatingsTotal ?? 0))",
                priceLevel: self.getPriceLevelSymbols(priceLevel: $0.priceLevel),
                openClosed: self.getOpenClosedText(isOpen: $0.openingHours?.openNow),
                restaurantImage: nil, // utilize caching? Extend UIImage?
                heartState: self.getHeartState(with: $0.placeID),
                placeID: $0.placeID,
                annotation: self.getMapAnnotation(
                    lat: $0.geometry?.location?.lat,
                    lng: $0.geometry?.location?.lng))
        }
    }
    
    func getRatingStarImage(rating: Double?) -> UIImage? {
        guard let rating = rating else { return nil }
        switch rating {
        case 0..<1.5: return oneStarImage
        case 1.5..<2.5: return twoStarImage
        case 2.5..<3.5: return threeStarImage
        case 3.5..<4.5: return fourStarImage
        default: return fiveStarImage
        }
    }
    
    func getPriceLevelSymbols(priceLevel: Int?) -> String? {
        guard let priceLevel = priceLevel else {
            return nil
        }
        
        switch priceLevel {
        case 0: return "FREE"
        case 1: return "$"
        case 2: return "$$"
        case 3: return "$$$"
        case 4: return "$$$$"
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        var favorites = [NSManagedObject]()
        do {
            favorites = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
        
        return favorites.contains(where: { $0.value(forKeyPath: "restaurantID") as? String == id })
    }
    
    // TODO: Extract core data funcs into CoreDataManager class
    func saveFavoritedRestaurant(id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)!
        let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
        favorite.setValue(id, forKeyPath: "restaurantID")
        do {
            try managedContext.save()
            guard let index = listViewContent.cellsContent.firstIndex(where: { $0.placeID == id }) else { return }
            listViewContent.cellsContent[index].heartState = .filled
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
    }
    
    func removeFavoritedRestaurant(id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "restaurantID == %@", id as CVarArg)
        do {
            let fetchedIDs = try managedContext.fetch(fetchRequest)
            fetchedIDs.forEach { managedContext.delete($0) }
            try managedContext.save()
            guard let index = listViewContent.cellsContent.firstIndex(where: { $0.placeID == id }) else { return }
            listViewContent.cellsContent[index].heartState = .empty
        } catch let error as NSError  {
            print("\(error), \(error.userInfo)")
        }
    }
    
    func getMapAnnotation(lat: Double?, lng: Double?) -> MKPointAnnotation? {
        guard let latitude = lat, let longitude = lng else { return nil }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return annotation
    }
    
    func getSelectedRestaurantContent(with coordinate: CLLocationCoordinate2D) -> RestaurantInfoView.Content? {
        return nil
//        restaurantsViewContent.cellContent.first(where: {
//            $0.annotation?.coordinate.latitude == coordinate.latitude &&
//            $0.annotation?.coordinate.longitude == coordinate.longitude
//        })
    }
}

