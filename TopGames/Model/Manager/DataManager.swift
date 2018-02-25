//
//  DataManager.swift
//  TopGames
//
//  Created by John Lima on 23/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation
import CoreData

struct DataManager {
    
    // MARK: - Properties
    private let databaseName = "DBGame"
    
    enum Entity: String {
        case game = "GameEntity"
        case image = "ImageEntity"
        case logo = "LogoEntity"
    }
    
    enum PredicateType: String {
        case equal = "=="
        case different = "<>"
        case AND = "AND"
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: databaseName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    mutating func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Actions
    mutating func getManagedObject(type: Entity) -> Any? {
        return NSEntityDescription.insertNewObject(forEntityName: type.rawValue, into: persistentContainer.viewContext)
    }
    
    mutating func fetchResult(from entity: Entity, predicate: NSPredicate? = nil) -> (items: [Any]?, error: String?) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        fetchRequest.predicate = predicate
        
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            return (results.count > 0 ? results : nil, nil)
        } catch {
            return (nil, error.localizedDescription)
        }
    }
    
    mutating func delete(entity: Entity, predicate: NSPredicate? = nil) -> Error? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        fetchRequest.predicate = predicate
        
        do {
            try persistentContainer.persistentStoreCoordinator.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest), with: persistentContainer.viewContext)
            return nil
        } catch {
            return error
        }
    }
    
    func record(_ context: NSManagedObjectContext?, completion: ((Error?) -> Void)? = nil) {
        context?.performAndWait {
            do {
                try context?.save()
                completion?(nil)
            } catch {
                completion?(error)
            }
        }
    }
    
    func predicate(id: Int?, key: String, type: PredicateType) -> NSPredicate? {
        guard let id = id else { return nil }
        return NSPredicate(format: "\(key) \(type.rawValue) %d", id)
    }
    
    func predicate(value: String?, key: String, type: PredicateType) -> NSPredicate? {
        guard let value = value, !value.isEmpty else {
            return NSPredicate(format: "\(key) \(type.rawValue) nil")
        }
        return NSPredicate(format: "\(key) \(type.rawValue) %@", value)
    }
    
    func showDataPath() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return }
        print("➭ CoreData url: \(url)")
    }
}

// MARK: - Extensions
extension Data {
    func toModel() -> GameModel? {
        return try? JSONDecoder().decode(GameModel.self, from: self)
    }
}

extension Collection {
    
    func noDuplicates() -> [GameModel]? {
        let models = (self as? [GameModel] ?? [])
        var result = [GameModel]()
        for model in models {
            let hasDuplicates = result.filter({ $0.game?.id == model.game?.id }).count > 0
            if !hasDuplicates {
                result.append(model)
            }
        }
        return result
    }
    
    func orderByViewers() -> [GameModel] {
        let models = (self as? [GameModel] ?? [])
        let result = models.sorted { $0.viewers > $1.viewers }
        return result
    }
    
    func toModel() -> GameModel? {
        guard let model = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted).toModel() else { return nil }
        return model
    }
    
    func toModels() -> [GameModel]? {
        var result = [GameModel]()
        for item in self {
            guard let model = try? JSONSerialization.data(withJSONObject: item, options: .prettyPrinted).toModel(), let obj = model?.checkFavorite() else { continue }
            result.append(obj)
        }
        return result
    }
    
    func checkFavorites() -> [GameModel]? {
        let models = self as? [GameModel]
        guard let items = models, items.count > 0 else { return models }
        var result = [GameModel]()
        for model in items {
            let item = model.checkFavorite()
            result.append(item)
        }
        return result
    }
}
