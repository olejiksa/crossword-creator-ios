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
        
        static let title = "new_title".localized
        static let message = "new_description".localized
        static let termsList = "new_option_dictionary".localized
        static let crossword = "new_option_crossword".localized
        static let cancel = "cancel".localized
    }
    
    
    // MARK: Private Properties
    
    var router: NewRouterProtocol?
    
    
    // MARK: Public
    
    static func create(with router: NewRouterProtocol?,
                       superview: UIView) -> NewAlertController {
        let newAlertController = NewAlertController(title: Constants.title,
                                                    message: Constants.message,
                                                    preferredStyle: .actionSheet)
        newAlertController.router = router
        newAlertController.setup(with: superview)
        
        return newAlertController
    }
    
    
    // MARK: Private
    
    private func setup(with superview: UIView) {
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
        
        if let popoverController = popoverPresentationController {
            popoverController.sourceView = superview
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
    }
}
