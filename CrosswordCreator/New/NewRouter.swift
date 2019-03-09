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
    func wantsToOpenGridEditor()
}

final class NewRouter: NewRouterProtocol {
    
    private weak var transitionHandler: ViewTransitionHandler?
    private weak var navigationTransitionHandler: NavigationTransitionHandler?
    
    init(transitionHandler: ViewTransitionHandler?,
         navigationTransitionHandler: NavigationTransitionHandler?) {
        self.transitionHandler = transitionHandler
        self.navigationTransitionHandler = navigationTransitionHandler
    }
    
    func wantsToOpenListEditor() {
        let listViewController = ListBuilder.viewController()
        let navigationController = UINavigationController(rootViewController: listViewController)
        
        transitionHandler?.present(navigationController)
    }
    
    func wantsToOpenGridEditor() {
        let gridViewController = GridBuilder.viewController(words: [])
        let navigationController = UINavigationController(rootViewController: gridViewController)
        
        transitionHandler?.present(navigationController)
    }
}
