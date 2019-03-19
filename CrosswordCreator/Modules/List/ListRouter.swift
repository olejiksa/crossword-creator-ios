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
    func wantsToSave()
}

final class ListRouter: ListRouterProtocol {
    
    typealias ListTransitionHandler = ViewTransitionHandler & WordAlertControllerDelegate & SaveAlertControllerDelegate
    
    private weak var transitionHandler: ListTransitionHandler?
    
    init(transitionHandler: ListTransitionHandler) {
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
    
    func wantsToSave() {
        let saveAlertController = SaveAlertController.create(with: .list)
        saveAlertController.delegate = transitionHandler
        transitionHandler?.present(saveAlertController)
    }
}