//
//  Controller+TransitionHandler.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

extension UINavigationController: NavigationTransitionHandler {
    
    func push(_ viewController: UIViewController) {
        pushViewController(viewController, animated: true)
    }
    
    func pop() {
        _ = popViewController(animated: true)
    }
}

extension UIViewController: ViewTransitionHandler {
    
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
   func dismiss() {
        dismiss(animated: true)
    }
}
