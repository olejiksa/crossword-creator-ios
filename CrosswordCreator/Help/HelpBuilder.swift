//
//  HelpBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class HelpBuilder {
    
    static func viewController() -> HelpViewController {
        let viewController = HelpViewController()
        _ = UINavigationController(rootViewController: viewController)
        
        return viewController
    }
}
