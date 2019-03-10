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
        
        let viewController = RecentsViewController(interactor: interactor)
        _ = UINavigationController(rootViewController: viewController)
        
        return viewController
    }
}
