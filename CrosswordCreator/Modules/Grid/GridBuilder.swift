//
//  GridBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

final class GridBuilder {
    
    static func viewController(words: [LayoutWord] = []) -> GridViewController {
        let interactor = GridInteractor()
        let gridDataSource = GridDataSource(interactor: interactor, words: words)
        
        let viewController = GridViewController(dataSource: gridDataSource)
        let router = GridRouter(transitionHandler: viewController)
        viewController.router = router
        
        return viewController
    }
}
