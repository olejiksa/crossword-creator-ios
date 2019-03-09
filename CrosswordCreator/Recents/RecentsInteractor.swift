//
//  RecentsInteractor.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 16/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

protocol RecentsInteractorProtocol: class {
    
    func getCrosswords() -> [String]
    func getCrosswordWithDates() -> [(String, Date)]
    func setupSearchableContent()
}

final class RecentsInteractor: RecentsInteractorProtocol {
    
    private let persistanceManager: PersistanceManager
    private let crosswordName = "Crossword"
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        persistanceManager = appDelegate.persistanceManager
    }
    
    func getCrosswords() -> [String] {
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: crosswordName)
        return crosswords.compactMap { $0.name }
    }
    
    func getCrosswordWithDates() -> [(String, Date)] {
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: crosswordName)
        return crosswords.compactMap {
            guard
                let title = $0.name,
                let date = $0.createdOn
            else { return nil }
            
            return (title, date)
        }
    }
    
    func setupSearchableContent() {
        var searchableItems = [CSSearchableItem]()
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: crosswordName)
        let dateFormatter = DateFormatter()
        
        for i in 0...(crosswords.count - 1) {
            let crossword = crosswords[i]
            
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            
            // Set the title.
            searchableItemAttributeSet.title = crossword.name
            
            // Set the image (no yet).
            
            // Set the description.
            if let updatedOn = crossword.updatedOn {
                searchableItemAttributeSet.contentDescription = dateFormatter.string(from: updatedOn)
            }
            
            searchableItemAttributeSet.thumbnailURL = Bundle.main.url(forResource: "home", withExtension: "pdf")
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: "com.olejiksa.crosswordCreator.\(i)",
                domainIdentifier: "crosswords", attributeSet: searchableItemAttributeSet)
            
            searchableItems.append(searchableItem)
        }
        
        CSSearchableIndex.default().indexSearchableItems(searchableItems)
    }
}
