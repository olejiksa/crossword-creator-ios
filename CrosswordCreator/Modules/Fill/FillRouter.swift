//
//  FillRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol FillRouterProtocol {
    
    func wantsToGoBack()
    func wantsToShare(with title: String, view: UIView, layoutWords: [LayoutWord])
    func wantsToFill(with filledWord: FilledWord)
    func wantsToSeeQuestions(with words: [LayoutWord])
}

final class FillRouter: FillRouterProtocol {
    
    typealias FillTransitionHandler = ViewTransitionHandler & FillAlertControllerDelegate & RollDelegate
    
    private weak var transitionHandler: FillTransitionHandler?
    private weak var navigationTransitionHandler: NavigationTransitionHandler?
    
    init(transitionHandler: FillTransitionHandler?,
         navigationTransitionHandler: NavigationTransitionHandler?) {
        self.transitionHandler = transitionHandler
        self.navigationTransitionHandler = navigationTransitionHandler
    }
    
    func wantsToGoBack() {
        transitionHandler?.dismiss()
    }
    
    func wantsToShare(with title: String, view: UIView, layoutWords: [LayoutWord]) {
        let wordType = ShareBuilder.WordType.gridWords(layoutWords)
        let shareViewController = ShareBuilder.viewController(with: title, wordType: wordType)
        shareViewController.popoverPresentationController?.sourceView = view
        transitionHandler?.present(shareViewController)
    }
    
    func wantsToFill(with filledWord: FilledWord) {
        let fillAlertController = FillBuilder.alertController(with: filledWord)
        fillAlertController.delegate = transitionHandler
        transitionHandler?.present(fillAlertController)
    }
    
    func wantsToSeeQuestions(with words: [LayoutWord]) {
        let rollViewController = RollBuilder.viewController(with: words, mode: .questions)
        rollViewController.delegate = transitionHandler
        navigationTransitionHandler?.push(rollViewController)
    }
}
