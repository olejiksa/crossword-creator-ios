//
//  RecentsBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RecentsBuilder {
    
    static func viewController() -> RecentsViewController {
        let interactor = RecentsInteractor()
        
        let vc = RecentsViewController(interactor: interactor)
        let navigationVC = UINavigationController(rootViewController: vc)
        
        let router = RecentsRouter(transitionHandler: navigationVC)
        vc.router = router
        
        return vc
    }
}
