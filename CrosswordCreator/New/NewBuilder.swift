//
//  NewBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class NewBuilder {
    
    static func viewController() -> NewViewController {
        let viewController = NewViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        let router = NewRouter(transitionHandler: viewController,
                               navigationTransitionHandler: navigationController)
        viewController.router = router
        
        return viewController
    }
}
