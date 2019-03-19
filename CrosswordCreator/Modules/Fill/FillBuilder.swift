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
    
    static func viewController(with title: String, words: [LayoutWord]) -> FillViewController {
        let fillDataSource = FillDataSource(words: words)
        
        let viewController = FillViewController(dataSource: fillDataSource, title: title)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let router = FillRouter(transitionHandler: viewController,
                                navigationTransitionHandler: navigationController)
        viewController.router = router
        
        return viewController
    }
}
