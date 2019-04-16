//
//  PersistanceService.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 16/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

protocol PersistanceServiceProtocol {
    
    func addDictionary(name: String, words: [Word])
    func updateDictionary(name: String, words: [Word])
    
    func addCrossword(name: String, words: [LayoutWord])
}

final class PersistanceService: PersistanceServiceProtocol {
    
    private enum Constants {
        static let crossword = "Crossword"
    }
    
    private let persistanceManager: PersistanceManager
    
    init(persistanceManager: PersistanceManager) {
        self.persistanceManager = persistanceManager
    }
    
    func addDictionary(name: String, words: [Word]) {
        let index = persistanceManager.fetch(entityName: Constants.crossword).count
        let crossword: Crossword = persistanceManager.insert()
        crossword.id = Int16(index)
        crossword.updatedOn = Date()
        crossword.createdOn = Date()
        crossword.name = name
        crossword.isTermsList = true
        
        let listWords: [ListWord] = words.enumerated().map {
            let listWord = ListWord(context: persistanceManager.managedContext)
            listWord.id = Int16($0)
            listWord.answer = $1.answer
            listWord.question = $1.question
            
            return listWord
        }
        
        crossword.words = NSOrderedSet(array: listWords)
        
        persistanceManager.save()
    }
    
    func updateDictionary(name: String, words: [Word]) {
        let crosswords: [Crossword] = persistanceManager.fetch(entityName: Constants.crossword)
        let crossword = crosswords.first { $0.name == name && $0.isTermsList }
        
        crossword?.updatedOn = Date()
        
        let listWords: [ListWord] = words.enumerated().map {
            let listWord = ListWord(context: persistanceManager.managedContext)
            listWord.id = Int16($0)
            listWord.answer = $1.answer
            listWord.question = $1.question
            
            return listWord
        }
        
        crossword?.words = NSOrderedSet(array: listWords)
        
        persistanceManager.save()
    }
    
    func addCrossword(name: String, words: [LayoutWord]) {
        let index = persistanceManager.fetch(entityName: Constants.crossword).count
        let crossword: Crossword = persistanceManager.insert()
        crossword.id = Int16(index)
        crossword.updatedOn = Date()
        crossword.createdOn = Date()
        crossword.name = name
        crossword.isTermsList = false
        
        let gridWords: [GridWord] = words.enumerated().map {
            let gridWord = GridWord(context: persistanceManager.managedContext)
            gridWord.id = Int16($0)
            gridWord.y = Int16(($1.row + 1) * 25)
            gridWord.x = Int16(($1.column + 1) * 25)
            gridWord.isHorizontal = $1.direction == .horizontal
            
            return gridWord
        }
        
        let listWords: [ListWord] = words.enumerated().map {
            let listWord = ListWord(context: persistanceManager.managedContext)
            listWord.id = Int16($0)
            listWord.answer = $1.answer
            listWord.question = $1.question
            listWord.gridWord = gridWords.first { $0.id == listWord.id }
            
            return listWord
        }
        
        crossword.words = NSOrderedSet(array: listWords)
        
        persistanceManager.save()
    }
}
