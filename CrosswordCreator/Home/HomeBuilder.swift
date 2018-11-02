//
//  HomeBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class HomeBuilder {
    
    class func viewController() -> HomeViewController {
        let viewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let router = HomeRouter(transitionHandler: navigationController)
        viewController.router = router
        
        return viewController
    }
}
