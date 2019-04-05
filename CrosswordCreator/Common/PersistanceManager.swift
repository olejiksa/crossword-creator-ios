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
            $0.setOption(CoreDataCoreSpotlightDelegate(forStoreWith: $0, model: container.managedObjectModel), forKey: NSCoreDataCoreSpotlightExporter)
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error: \(error)")
            }
        }
        
        return container
    }()
    
    private lazy var managedContext: NSManagedObjectContext = {
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
        } catch {
            fatalError("An error occurred while saving: \(error)")
        }
    }
    
    func appendNewTermsList(name: String, words: [Word]) {
        let index = fetch(entityName: "Crossword").count
        let crossword: Crossword = insert()
        crossword.id = Int16(index)
        crossword.updatedOn = Date()
        crossword.createdOn = Date()
        crossword.name = name
        crossword.isTermsList = true
        
        let listWords: [ListWord] = words.enumerated().map {
            let listWord = ListWord(context: managedContext)
            listWord.id = Int16($0)
            listWord.answer = $1.answer
            listWord.question = $1.question
            
            return listWord
        }
        
        crossword.words = NSOrderedSet(array: listWords)
        
        save()
    }
    
    func updateTermsList(name: String, words: [Word]) {
        let crosswords: [Crossword] = fetch(entityName: "Crossword")
        let crossword = crosswords.first { $0.name == name && $0.isTermsList }
        
        crossword?.updatedOn = Date()
        
        let listWords: [ListWord] = words.enumerated().map {
            let listWord = ListWord(context: managedContext)
            listWord.id = Int16($0)
            listWord.answer = $1.answer
            listWord.question = $1.question
            
            return listWord
        }
        
        crossword?.words = NSOrderedSet(array: listWords)
        
        save()
    }
    
    func appendNewCrossword(name: String, words: [LayoutWord]) {
        let index = fetch(entityName: "Crossword").count
        let crossword: Crossword = insert()
        crossword.id = Int16(index)
        crossword.updatedOn = Date()
        crossword.createdOn = Date()
        crossword.name = name
        crossword.isTermsList = false
        
        let gridWords: [GridWord] = words.enumerated().map {
            let gridWord = GridWord(context: managedContext)
            gridWord.id = Int16($0)
            gridWord.y = Int16(($1.row + 1) * 25)
            gridWord.x = Int16(($1.column + 1) * 25)
            gridWord.isHorizontal = $1.direction == .horizontal
            
            return gridWord
        }
        
        let listWords: [ListWord] = words.enumerated().map {
            let listWord = ListWord(context: managedContext)
            listWord.id = Int16($0)
            listWord.answer = $1.answer
            listWord.question = $1.question
            listWord.gridWord = gridWords.first { $0.id == listWord.id }
            
            return listWord
        }
        
        crossword.words = NSOrderedSet(array: listWords)
        
        save()
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
    
    private func insert<T>() -> T where T: NSManagedObject {
        return T(context: managedContext)
    }
}
