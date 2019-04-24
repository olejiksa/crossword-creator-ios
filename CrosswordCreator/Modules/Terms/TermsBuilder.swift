//
//  TermsBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TermsBuilder {
    
    static func viewController() -> TermsViewController {
        let viewController = TermsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        let router = TermsRouter(transitionHandler: viewController,
                                 navigationTransitionHandler: navigationController)
        viewController.router = router
        return viewController
    }
}
