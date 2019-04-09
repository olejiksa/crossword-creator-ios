//
//  RecentsRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 15/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol RecentsRouterProtocol {
    
    func wantsToOpenListEditor(with title: String, words: [Word])
    func wantsToFill(with title: String, words: [LayoutWord])
    func wantsToCreate(with viewController: UIViewController)
}

final class RecentsRouter: RecentsRouterProtocol {
    
    private weak var transitionHandler: ViewTransitionHandler?
    
    init(transitionHandler: ViewTransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToOpenListEditor(with title: String, words: [Word]) {
        let vc = ListBuilder.viewController(with: title, words: words)
        let nvc = UINavigationController(rootViewController: vc)
        transitionHandler?.present(nvc)
    }
    
    func wantsToFill(with title: String, words: [LayoutWord]) {
        let vc = FillBuilder.viewController(with: title, words: words)
        if let nvc = vc.navigationController {
            transitionHandler?.present(nvc)
        }
    }
    
    func wantsToCreate(with viewController: UIViewController) {
        let ac = NewBuilder.alertController(with: viewController)
        transitionHandler?.present(ac)
    }
}
