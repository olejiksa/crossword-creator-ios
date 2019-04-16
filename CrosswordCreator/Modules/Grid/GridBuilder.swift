//
//  GridBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

final class GridBuilder {
    
    static func viewController(words: [LayoutWord] = []) -> GridViewController {
        let persistanceService = ServiceLocator.persistanceService
        let interactor = GridInteractor(persistanceService: persistanceService)
        let xmlService = ServiceLocator.xmlService
        let dataSource = GridDataSource(interactor: interactor, words: words)
        
        let viewController = GridViewController(dataSource: dataSource,
                                                xmlService: xmlService)
        
        let router = GridRouter(transitionHandler: viewController)
        viewController.router = router
        
        return viewController
    }
}
