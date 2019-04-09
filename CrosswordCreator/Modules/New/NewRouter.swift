//
//  NewRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 03/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol NewRouterProtocol {
    
    func wantsToOpenListEditor()
    func wantsToOpenListEditor(_ action: UIAlertAction)
    
    func wantsToOpenGridEditor()
    func wantsToOpenGridEditor(_ action: UIAlertAction)
}

final class NewRouter: NewRouterProtocol {
    
    private weak var transitionHandler: ViewTransitionHandler?
    
    init(transitionHandler: ViewTransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToOpenListEditor() {
        let listViewController = ListBuilder.viewController()
        let navigationController = UINavigationController(rootViewController: listViewController)
        transitionHandler?.present(navigationController)
    }
    
    func wantsToOpenListEditor(_ action: UIAlertAction) {
        wantsToOpenListEditor()
    }
    
    func wantsToOpenGridEditor() {
        let gridViewController = GridBuilder.viewController(words: [])
        let navigationController = UINavigationController(rootViewController: gridViewController)
        transitionHandler?.present(navigationController)
    }
    
    func wantsToOpenGridEditor(_ action: UIAlertAction) {
        wantsToOpenGridEditor()
    }
}
