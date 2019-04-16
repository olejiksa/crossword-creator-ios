//
//  WordBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

final class WordBuilder {
    
    static func viewController(with mode: Mode) -> WordViewController {
        let viewController: WordViewController
        
        switch mode {
        case .new:
            viewController = WordViewController()
            
        case .edit(let word, let index):
            viewController = WordViewController((word, index))
        }
        
        return viewController
    }
    
    enum Mode {
        
        case new
        case edit(Word, Int)
    }
}
