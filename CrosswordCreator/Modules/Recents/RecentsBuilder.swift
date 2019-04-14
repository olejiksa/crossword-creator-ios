//
//  RecentsBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RecentsBuilder {
    
    static func viewController(with mode: RecentsViewController.Mode = .standard,
                               moduleOutput: RecentsModuleOutput? = nil) -> RecentsViewController {
        let interactor = RecentsInteractor(onlyTerms: mode == .picker)
        
        let vc = RecentsViewController(interactor: interactor, mode: mode)
        let navigationVC = UINavigationController(rootViewController: vc)
        
        let router = RecentsRouter(transitionHandler: navigationVC)
        vc.router = router
        
        vc.moduleOutput = moduleOutput
        
        return vc
    }
}
