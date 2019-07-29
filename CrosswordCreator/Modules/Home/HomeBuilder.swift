//
//  HomeBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class HomeBuilder {
    
    static func viewController(with mode: HomeViewController.Mode = .standard,
                               moduleOutput: HomeModuleOutput? = nil) -> HomeViewController {
        let interactor = HomeInteractor(onlyTerms: mode == .picker)
        
        let vc = HomeViewController(interactor: interactor, mode: mode)
        let navigationVC = UINavigationController(rootViewController: vc)
        
        let router = HomeRouter(transitionHandler: navigationVC)
        vc.router = router
        
        vc.moduleOutput = moduleOutput
        
        return vc
    }
}
