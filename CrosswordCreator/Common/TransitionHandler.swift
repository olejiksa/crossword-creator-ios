//
//  TransitionHandler.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol NavigationTransitionHandler: class {
    
    func push(_ viewController: UIViewController)
}

protocol ViewTransitionHandler: class {
    
    func present(_ viewController: UIViewController)
}
