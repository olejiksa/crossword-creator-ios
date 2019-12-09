//
//  AboutRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

protocol AboutRouterProtocol {
 
    func wantsToGoBack()
}

final class AboutRouter: AboutRouterProtocol {
    
    private weak var transitionHandler: ViewTransitionHandler?
    
    init(transitionHandler: ViewTransitionHandler?) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToGoBack() {
        transitionHandler?.dismiss()
    }
}
