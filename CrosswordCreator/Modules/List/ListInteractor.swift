//
//  ListInteractor.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 08/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol ListInteractorProtocol: class {
    
    func getWords() -> [Word]
    func updateWord(_ orderedWord: OrderedWord)
    func removeWord(at index: Int)
    func save(_ words: [Word], with title: String, mode: Bool)
}

final class ListInteractor: ListInteractorProtocol {
    
    private enum Constants {
        static let listWordName = "ListWord"
        static let crosswordName = "Crossword"
    }
    
    private let persistanceManager: PersistanceManager
    private let persistanceService: PersistanceServiceProtocol
    
    init(persistanceService: PersistanceServiceProtocol) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        persistanceManager = appDelegate.persistanceManager
        
        self.persistanceService = persistanceService
    }
    
    func getWords() -> [Word] {
        let crossword: Crossword? = persistanceManager.findOrInsert(by: 0, entityName: Constants.crosswordName)
        
        let words: [ListWord] = persistanceManager.fetchThatSatisfies(entityName: Constants.listWordName,
                                                                      predicate: { $0.crossword == crossword })
        return words.compactMap { listWord -> Word? in
            guard
                let question = listWord.question,
                let answer = listWord.answer
            else { return nil }
            
            return Word(question: question, answer: answer)
        }
    }
    
    private func getOrderedWords(startIndex: Int) -> [OrderedWord] {
        let words: [ListWord] = persistanceManager.fetch(startIndex: startIndex,
                                                         entityName: Constants.listWordName)
        return words.compactMap { listWord -> OrderedWord? in
            guard
                let question = listWord.question,
                let answer = listWord.answer
            else { return nil }
            
            let word = Word(question: question, answer: answer)
            return (word: word, index: Int(listWord.id))
        }
    }
    
    func updateWord(_ orderedWord: OrderedWord) {
        let listWord: ListWord? = persistanceManager.findOrInsert(by: orderedWord.index, entityName: Constants.listWordName)
        listWord?.id = Int16(orderedWord.index)
        listWord?.question = orderedWord.word.question
        listWord?.answer = orderedWord.word.answer
        persistanceManager.save()
    }
    
    private func updateIndex(_ word: OrderedWord) {
        guard let listWord: ListWord = persistanceManager.findOrInsert(by: word.index, entityName: Constants.listWordName) else { return }
        listWord.id -= 1
    }
    
    func removeWord(at index: Int) {
        persistanceManager.remove(by: index, entityName: Constants.listWordName)
        
        let orderedWords = getOrderedWords(startIndex: index)
        orderedWords.forEach(updateIndex)
        
        persistanceManager.save()
    }
    
    func save(_ words: [Word], with title: String, mode: Bool) {
        if !mode {
            persistanceService.addDictionary(name: title, words: words)
        } else {
            persistanceService.updateDictionary(name: title, words: words)
        }
    }
}
