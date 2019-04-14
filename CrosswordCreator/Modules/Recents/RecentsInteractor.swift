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
    func getCrosswordWithDates() -> [(String, Date, Bool)]
    func setupSearchableContent()
    
    func isTermsList(at index: Int) -> Bool
    func getLayoutWords(at index: Int) -> [LayoutWord]
    func getWords(at index: Int) -> [Word]
    
    func removeCrossword(at index: Int)
}

final class RecentsInteractor: RecentsInteractorProtocol {
    
    private let persistanceManager: PersistanceManager
    private let crosswordName = "Crossword"
    private let onlyTerms: Bool
    
    init(onlyTerms: Bool) {
        self.onlyTerms = onlyTerms
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        persistanceManager = appDelegate.persistanceManager
    }
    
    func getCrosswords() -> [String] {
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: crosswordName)
        let filtered = onlyTerms ? crosswords.filter { $0.isTermsList } : crosswords
        
        return filtered.map { $0.name ?? "Untitled" }
    }
    
    func getCrosswordWithDates() -> [(String, Date, Bool)] {
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: crosswordName)
        let filtered = onlyTerms ? crosswords.filter { $0.isTermsList } : crosswords
        
        return filtered.map { ($0.name ?? "Untitled", $0.updatedOn ?? Date(), $0.isTermsList) }
    }
    
    func getLayoutWords(at index: Int) -> [LayoutWord] {
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: crosswordName)
        guard !crosswords[index].isTermsList else { return [] }
        guard let casted = crosswords[index].words else { return [] }
        guard let array = casted.array as? [ListWord] else { return [] }
        
        return array.map { LayoutWord(question: $0.question!,
                                      answer: $0.answer!,
                                      column: Int($0.gridWord!.x / 25),
                                      row: Int($0.gridWord!.y / 25),
                                      direction: $0.gridWord!.isHorizontal ? .horizontal : .vertical) }
    }
    
    func getWords(at index: Int) -> [Word] {
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: crosswordName)
        let filtered = onlyTerms ? crosswords.filter { $0.isTermsList } : crosswords
        guard let casted = filtered[index].words else { return [] }
        guard let array = casted.array as? [ListWord] else { return [] }
        
        return array.map { Word(question: $0.question!, answer: $0.answer!) }
    }
    
    func setupSearchableContent() {
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: crosswordName)
        guard !crosswords.isEmpty else { return }
        
        var searchableItems = [CSSearchableItem]()
        let dateFormatter = DateFormatter()
        
        for i in 0..<crosswords.count {
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
    
    func removeCrossword(at index: Int) {
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: crosswordName)
        persistanceManager.remove(crosswords[index])
        persistanceManager.save()
    }
    
    func isTermsList(at index: Int) -> Bool {
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: crosswordName)
        return crosswords[index].isTermsList
    }
}
