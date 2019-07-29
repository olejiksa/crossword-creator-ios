//
//  TermsRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol TermsRouterProtocol {
    
    func wantsToGoBack()
    func wantsToOpen(with inputVC: HomeModuleOutput)
    func wantsToGenerate(with words: [Word])
}

final class TermsRouter: TermsRouterProtocol {
    
    private weak var transitionHandler: ViewTransitionHandler?
    private weak var navigationTransitionHandler: NavigationTransitionHandler?
    
    init(transitionHandler: ViewTransitionHandler,
         navigationTransitionHandler: NavigationTransitionHandler?) {
        self.transitionHandler = transitionHandler
        self.navigationTransitionHandler = navigationTransitionHandler
    }
    
    func wantsToGoBack() {
        transitionHandler?.dismiss()
    }
    
    func wantsToOpen(with inputVC: HomeModuleOutput) {
        let vc = HomeBuilder.viewController(with: .picker, moduleOutput: inputVC)
        if let nvc = vc.navigationController {
            transitionHandler?.present(nvc)
        }
    }
    
    func wantsToGenerate(with words: [Word]) {
        // let gridViewController = GridBuilder.viewController(words: words)
        // navigationTransitionHandler?.push(gridViewController)
        let creationViewController = CreationBuilder.viewController(with: words, navigationTransitionHandler: navigationTransitionHandler)
        navigationTransitionHandler?.push(creationViewController)
    }
}
