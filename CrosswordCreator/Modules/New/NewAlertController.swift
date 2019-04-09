//
//  NewAlertController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class NewAlertController: UIAlertController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "New"
        static let message = "Create new terms list or crossword"
        static let termsList = "Terms List"
        static let crossword = "Crossword"
        static let cancel = "Cancel"
    }
    
    
    // MARK: Private Properties
    
    var router: NewRouterProtocol?
    
    
    // MARK: Public
    
    static func create(with router: NewRouterProtocol?) -> NewAlertController {
        let newAlertController = NewAlertController(title: Constants.title,
                                                    message: Constants.message,
                                                    preferredStyle: .actionSheet)
        newAlertController.router = router
        newAlertController.setup()
        
        return newAlertController
    }
    
    
    // MARK: Private
    
    private func setup() {
        let createTermsListAction = UIAlertAction(title: Constants.termsList,
                                                  style: .default,
                                                  handler: router?.wantsToOpenListEditor(_:))
        addAction(createTermsListAction)
        
        let createCrosswordAction = UIAlertAction(title: Constants.crossword,
                                                  style: .default,
                                                  handler: router?.wantsToOpenGridEditor(_:))
        addAction(createCrosswordAction)
        
        let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel)
        addAction(cancelAction)
    }
}
