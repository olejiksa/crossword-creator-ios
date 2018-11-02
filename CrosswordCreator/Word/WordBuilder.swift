//
//  WordBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

final class WordBuilder {
    
    class func alertController(with mode: Mode) -> WordAlertController {
        let alertController: WordAlertController
        
        switch mode {
        case .new:
            alertController = WordAlertController.create()
            
        case .edit(let word, let index):
            alertController = WordAlertController.create(with: (word, index))
        }
        
        return alertController
    }
    
    enum Mode {
        
        case new
        case edit(Word, Int)
    }
}
