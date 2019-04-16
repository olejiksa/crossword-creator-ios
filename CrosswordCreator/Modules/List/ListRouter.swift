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
    func wantsToShare(with title: String, view: UIView, words: [Word])
}

final class ListRouter: ListRouterProtocol {
    
    typealias ListTransitionHandler = ViewTransitionHandler & WordViewControllerDelegate & SaveAlertControllerDelegate
    
    private weak var transitionHandler: ListTransitionHandler?
    private weak var navigationTransitionHandler: NavigationTransitionHandler?
    
    init(transitionHandler: ListTransitionHandler,
         navigationTransitionHandler: NavigationTransitionHandler?) {
        self.transitionHandler = transitionHandler
        self.navigationTransitionHandler = navigationTransitionHandler
    }
    
    func wantsToOpenWordEditor(with mode: WordBuilder.Mode) {
        let wordAlertController = WordBuilder.viewController(with: mode)
        wordAlertController.delegate = transitionHandler
        navigationTransitionHandler?.push(wordAlertController)
    }
    
    func wantsToGoBack() {
        transitionHandler?.dismiss()
    }
    
    func wantsToSave() {
        let saveAlertController = SaveBuilder.alertController(with: .list)
        saveAlertController.delegate = transitionHandler
        transitionHandler?.present(saveAlertController)
    }
    
    func wantsToShare(with title: String, view: UIView, words: [Word]) {
        let wordType = ShareBuilder.WordType.listWords(words)
        let shareViewController = ShareBuilder.viewController(with: title, wordType: wordType)
        shareViewController.popoverPresentationController?.sourceView = view
        transitionHandler?.present(shareViewController)
    }
}
