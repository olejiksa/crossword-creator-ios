//
//  ListBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

final class ListBuilder {
    
    class func viewController() -> ListViewController {
        let dataSource = ListDataSource()
        let viewController = ListViewController(dataSource: dataSource)
       
        let router = ListRouter(transitionHandler: viewController)
        viewController.router = router
        
        return viewController
    }
}
