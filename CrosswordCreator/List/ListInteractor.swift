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
    func getCrosswordName() -> String
    func updateWord(_ orderedWord: OrderedWord)
    func removeWord(at index: Int)
}

final class ListInteractor: ListInteractorProtocol {
    
    private let persistanceManager: PersistanceManager
    private let listWordName = "ListWord"
    private let crosswordName = "Crossword"
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        persistanceManager = appDelegate.persistanceManager
    }
    
    func getWords() -> [Word] {
        let crossword: Crossword? = persistanceManager.findOrInsert(by: 1, entityName: crosswordName)
        
        let words: [ListWord] = persistanceManager.fetchThatSatisfies(entityName: listWordName,
                                                                      predicate: { $0.crossword == crossword })
        return words.compactMap { listWord -> Word? in
            guard
                let question = listWord.question,
                let answer = listWord.answer
            else { return nil }
            
            return Word(question: question, answer: answer)
        }
    }
    
    func getCrosswordName() -> String {
        let crossword: Crossword? = persistanceManager.fetch(entityName: crosswordName).first
        return crossword?.name ?? "Untitled"
    }
    
    private func getOrderedWords(startIndex: Int) -> [OrderedWord] {
        let words: [ListWord] = persistanceManager.fetch(startIndex: startIndex,
                                                         entityName: listWordName)
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
        let listWord: ListWord? = persistanceManager.findOrInsert(by: orderedWord.index, entityName: listWordName)
        listWord?.id = Int16(orderedWord.index)
        listWord?.question = orderedWord.word.question
        listWord?.answer = orderedWord.word.answer
        persistanceManager.save()
    }
    
    private func updateIndex(_ word: OrderedWord) {
        guard let listWord: ListWord = persistanceManager.findOrInsert(by: word.index, entityName: listWordName) else { return }
        listWord.id -= 1
    }
    
    func removeWord(at index: Int) {
        persistanceManager.remove(by: index, entityName: listWordName)
        
        let orderedWords = getOrderedWords(startIndex: index)
        orderedWords.forEach(updateIndex)
        
        persistanceManager.save()
    }
}
