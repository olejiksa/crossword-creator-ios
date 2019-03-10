//
//  FillBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

final class FillBuilder {
    
    static func viewController(words: [LayoutWord] = []) -> FillViewController {
        let fillDataSource = FillDataSource(words: words)
        
        let viewController = FillViewController(dataSource: fillDataSource)
        let router = FillRouter(transitionHandler: viewController)
        viewController.router = router
        
        return viewController
    }
}
