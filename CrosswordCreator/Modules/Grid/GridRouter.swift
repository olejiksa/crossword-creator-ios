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
    func wantsToShare(with title: String, view: UIView, layoutWords: [LayoutWord])
    func wantsToGoBack()
}

final class GridRouter: GridRouterProtocol {
    
    typealias SaveTransitionHandler = ViewTransitionHandler & SaveAlertControllerDelegate
    
    private weak var transitionHandler: SaveTransitionHandler?
    
    init(transitionHandler: SaveTransitionHandler?) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToSave() {
        let saveAlertController = SaveBuilder.alertController(with: .grid)
        saveAlertController.delegate = transitionHandler
        transitionHandler?.present(saveAlertController)
    }
    
    func wantsToShare(with title: String, view: UIView, layoutWords: [LayoutWord]) {
        let wordType = ShareBuilder.WordType.gridWords(layoutWords)
        let shareViewController = ShareBuilder.viewController(with: title, wordType: wordType)
        shareViewController.popoverPresentationController?.sourceView = view
        transitionHandler?.present(shareViewController)
    }
    
    func wantsToGoBack() {
        transitionHandler?.dismiss()
    }
}
