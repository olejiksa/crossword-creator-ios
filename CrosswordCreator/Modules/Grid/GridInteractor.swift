//
//  GridInteractor.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 16/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol GridInteractorProtocol: class {
    
    func save(_ words: [LayoutWord], with title: String)
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
    
    func save(_ words: [LayoutWord], with title: String) {
        persistanceManager.appendNewCrossword(name: title, words: words)
    }
}
