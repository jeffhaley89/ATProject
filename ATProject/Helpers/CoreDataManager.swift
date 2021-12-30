//
//  CoreDataManager.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/22/21.
//

import CoreData
import UIKit

class CoreDataManager {
    enum Entity: String {
        case favorite = "Favorite"
    }
    
    enum Attribute: String {
        case restaurantID = "restaurantID"
    }
    
    static let shared = CoreDataManager()
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveFavoritedRestaurant(id: String, completion: (Bool) -> ()) {
        guard let managedContext = managedContext,
              let entity = NSEntityDescription.entity(forEntityName: Entity.favorite.rawValue, in: managedContext) else { return }
        let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
        favorite.setValue(id, forKeyPath: Attribute.restaurantID.rawValue)
        do {
            try managedContext.saveIfNeeded()
            completion(true)
        } catch let error as NSError {
            completion(false)
            print("\(error), \(error.userInfo)")
        }
    }
    
    func removeFavoritedRestaurant(id: String, completion: (Bool) -> ()) {
        guard let managedContext = managedContext else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.favorite.rawValue)
        fetchRequest.predicate = NSPredicate(format: "\(Attribute.restaurantID.rawValue) == %@", id as CVarArg)
        do {
            let fetchedIDs = try managedContext.fetch(fetchRequest)
            fetchedIDs.forEach { managedContext.delete($0) }
            try managedContext.saveIfNeeded()
            completion(true)
        } catch let error as NSError {
            completion(false)
            print("\(error), \(error.userInfo)")
        }
    }
    
    func getAllFavoritedRestaurants() -> [NSManagedObject] {
        guard let managedContext = managedContext else { return [] }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.favorite.rawValue)
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return []
        }
    }
}

extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        guard hasChanges else { return }
        try save()
    }
}
