//
//  CreationRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 14/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

protocol CreationRouterProtocol {
 
    func wantsToNext(with words: [LayoutWord])
}

final class CreationRouter: CreationRouterProtocol {
 
    private weak var transitionHandler: ViewTransitionHandler?
    private weak var navigationTransitionHandler: NavigationTransitionHandler?
    
    init(transitionHandler: ViewTransitionHandler,
         navigationTransitionHandler: NavigationTransitionHandler?) {
        self.transitionHandler = transitionHandler
        self.navigationTransitionHandler = navigationTransitionHandler
    }
    
    func wantsToNext(with words: [LayoutWord]) {
        let gridViewController = GridBuilder.viewController(words: words)
        navigationTransitionHandler?.push(gridViewController)
    }
}
