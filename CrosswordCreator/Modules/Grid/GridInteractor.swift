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
    
    private let persistanceService: PersistanceServiceProtocol
    
    init(persistanceService: PersistanceServiceProtocol) {
        self.persistanceService = persistanceService
    }
    
    func save(_ words: [LayoutWord], with title: String) {
        persistanceService.addCrossword(name: title, words: words)
    }
}
