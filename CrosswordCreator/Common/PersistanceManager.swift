//
//  PersistanceManager.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 08/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

final class PersistanceManager {
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        
        container.persistentStoreDescriptions.forEach {
            $0.setOption(NSCoreDataCoreSpotlightDelegate(forStoreWith: $0, model: container.managedObjectModel), forKey: NSCoreDataCoreSpotlightExporter)
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error: \(error)")
            }
        }
        
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return container.viewContext
    }()
    
    
    // MARK: Public
    
    func fetch<T>(entityName: String) -> [T] where T: NSManagedObject {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func fetch<T>(startIndex: Int, entityName: String) -> [T] where T: NSManagedObject {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id >= %d", startIndex as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func fetchThatSatisfies<T>(entityName: String, predicate: ((T) -> Bool)) -> [T] where T: NSManagedObject {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            return try managedContext.fetch(fetchRequest).filter(predicate)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func findOrInsert<T>(by primaryKey: Int,
                         entityName: String) -> T? where T: NSManagedObject {
        if let managedObject = find(by: primaryKey, entityName: entityName) {
            return managedObject as? T
        } else {
            return insert()
        }
    }
    
    func remove(by primaryKey: Int, entityName: String) {
        if let managedObject = find(by: primaryKey, entityName: entityName) {
            managedContext.delete(managedObject)
        }
    }
    
    func remove(_ managedObject: NSManagedObject) {
        managedContext.delete(managedObject)
    }
    
    func save() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTheTable"), object: nil)
        } catch {
            fatalError("An error occurred while saving: \(error)")
        }
    }
    
    func insert<T>() -> T where T: NSManagedObject {
        return T(context: managedContext)
    }
    
    
    // MARK: Private
    
    private func find<T>(by primaryKey: Int,
                         entityName: String) -> T? where T: NSManagedObject {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %d", primaryKey as CVarArg)
        
        do {
            if let managedObject = try managedContext.fetch(fetchRequest).first {
                return managedObject
            }
        } catch {
            print("Couldn't find: \(error)")
        }
        
        return nil
    }
}
