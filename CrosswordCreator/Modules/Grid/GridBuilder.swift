//
//  GridBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

final class GridBuilder {
    
    static func viewController(words: [Word] = []) -> GridViewController {
        let generator = CrosswordsGenerator(columns: 32,
                                            rows: 32,
                                            words: words.map { ($0.question, $0.answer) })
        
        let interactor = GridInteractor()
        let gridDataSource = GridDataSource(generator: generator,
                                            interactor: interactor)
        
        let viewController = GridViewController(dataSource: gridDataSource)
        let router = GridRouter(transitionHandler: viewController)
        viewController.router = router
        
        return viewController
    }
}
