//
//  GridInteractor.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 16/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol GridInteractorProtocol: class {
    
    func saveGrid(_ words: [LayoutWord], with title: String)
}

final class GridInteractor: GridInteractorProtocol {
    
    private enum Constants {
        
        static let listWordName = "ListWord"
        static let gridWordName = "GridWord"
        static let crosswordName = "Crossword"
    }
    
    private let persistanceManager: PersistanceManager
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        persistanceManager = appDelegate.persistanceManager
    }
    
    func saveGrid(_ words: [LayoutWord], with title: String) {
        let crossword: Crossword? = persistanceManager.findOrInsert(by: 0, entityName: Constants.crosswordName)
        
        let date = Date()
        
        if crossword?.createdOn == nil {
            crossword?.createdOn = date
        }
        
        crossword?.updatedOn = date
        crossword?.name = title
        
        words.enumerated().forEach { (index, word) in
            let listWord: ListWord? = persistanceManager.findOrInsert(by: index, entityName: Constants.listWordName)
            let gridWord: GridWord? = persistanceManager.findOrInsert(by: index, entityName: Constants.gridWordName)
            gridWord?.x = Int16(word.column)
            gridWord?.y = Int16(word.row)
            gridWord?.isHorizontal = word.direction == .horizontal
            
            listWord?.gridWord = gridWord
            listWord?.crossword = crossword
        }
        
        persistanceManager.save()
    }
}
