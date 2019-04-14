//
//  CreationBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 14/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class CreationBuilder {
    
    static func viewController(with words: [Word], navigationTransitionHandler: NavigationTransitionHandler?) -> CreationViewController {
        let viewController = CreationViewController()
        let router = CreationRouter(transitionHandler: viewController, navigationTransitionHandler: navigationTransitionHandler)
        viewController.words = words
        viewController.router = router
        
        return viewController
    }
}
