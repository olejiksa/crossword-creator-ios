//
//  ListBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListBuilder {
    
    private enum Constants {
        static let untitled = "Untitled"
    }
    
    static func viewController() -> ListViewController {
        return viewController(with: Constants.untitled, words: [])
    }
    
    static func viewController(with title: String, words: [Word]) -> ListViewController {
        let persistanceService = ServiceLocator.persistanceService
        let interactor = ListInteractor(persistanceService: persistanceService)
        let dataSource = ListDataSource(interactor: interactor,
                                        words: words,
                                        title: title)
        let xmlService = ServiceLocator.xmlService
        
        let mode = !words.isEmpty
        let viewController = ListViewController(dataSource: dataSource,
                                                xmlService: xmlService,
                                                mode: mode)
        let nvc = UINavigationController(rootViewController: viewController)
        
        let router = ListRouter(transitionHandler: viewController,
                                navigationTransitionHandler: nvc)
        viewController.router = router
        dataSource.vc = viewController
        
        return viewController
    }
}
