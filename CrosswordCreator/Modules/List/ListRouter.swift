//
//  ListRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol ListRouterProtocol {
    
    func wantsToOpenWordEditor(with: WordBuilder.Mode)
    func wantsToGoBack()
}

final class ListRouter: ListRouterProtocol {
    
    typealias WordTransitionHandler = ViewTransitionHandler & WordAlertControllerDelegate
    
    private weak var transitionHandler: WordTransitionHandler?
    
    init(transitionHandler: WordTransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToOpenWordEditor(with mode: WordBuilder.Mode) {
        let wordAlertController = WordBuilder.alertController(with: mode)
        wordAlertController.delegate = transitionHandler
        
        transitionHandler?.present(wordAlertController)
    }
    
    func wantsToGoBack() {
        transitionHandler?.dismiss()
    }
}
