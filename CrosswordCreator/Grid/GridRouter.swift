//
//  GridRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 03/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol GridRouterProtocol {
    
    func wantsToSave()
    func wantsToGoBack()
}

final class GridRouter: GridRouterProtocol {
    
    typealias SaveTransitionHandler = ViewTransitionHandler & SaveAlertControllerDelegate
    
    private weak var transitionHandler: SaveTransitionHandler?
    
    init(transitionHandler: SaveTransitionHandler?) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToSave() {
        let saveAlertController = SaveAlertController.create()
        saveAlertController.delegate = transitionHandler
        transitionHandler?.present(saveAlertController)
    }
    
    func wantsToGoBack() {
        transitionHandler?.dismiss()
    }
}
