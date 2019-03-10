//
//  FillRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol FillRouterProtocol {
    
    func wantsToGoBack()
}

final class FillRouter: FillRouterProtocol {
    
    private weak var transitionHandler: ViewTransitionHandler?
    
    init(transitionHandler: ViewTransitionHandler?) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToGoBack() {
        transitionHandler?.dismiss()
    }
}
