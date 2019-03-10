//
//  ListBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

final class ListBuilder {
    
    static func viewController() -> ListViewController {
        let interactor = ListInteractor()
        let dataSource = ListDataSource(interactor: interactor)
        let xmlService = XmlService()
        
        let viewController = ListViewController(dataSource: dataSource,
                                                xmlService: xmlService)
        let router = ListRouter(transitionHandler: viewController)
        viewController.router = router
        dataSource.vc = viewController
        
        return viewController
    }
}
