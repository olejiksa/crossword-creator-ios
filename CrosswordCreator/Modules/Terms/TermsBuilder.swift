//
//  TermsBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

final class TermsBuilder {
    
    static func viewController() -> TermsViewController {
        let viewController = TermsViewController()
        let router = TermsRouter(transitionHandler: viewController)
        viewController.router = router
        return viewController
    }
}
