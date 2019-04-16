//
//  FillBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class FillBuilder {
    
    static func alertController(with filledWord: FilledWord) -> FillAlertController {
        return FillAlertController.create(with: filledWord)
    }
    
    static func viewController(with title: String,
                               words: [LayoutWord]) -> FillViewController {
        let dataSource = FillDataSource(words: words)
        let xmlService = ServiceLocator.xmlService
        
        let viewController = FillViewController(dataSource: dataSource,
                                                xmlService: xmlService,
                                                title: title)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let router = FillRouter(transitionHandler: viewController,
                                navigationTransitionHandler: navigationController)
        viewController.router = router
        
        return viewController
    }
}
