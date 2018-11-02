//
//  HomeRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol HomeRouterProtocol {
    
    func wantsToOpenListEditor()
}

final class HomeRouter: HomeRouterProtocol {
    
    private weak var transitionHandler: NavigationTransitionHandler?
    
    init(transitionHandler: NavigationTransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToOpenListEditor() {
        let listViewController = ListBuilder.viewController()
        transitionHandler?.push(listViewController)
    }
}
