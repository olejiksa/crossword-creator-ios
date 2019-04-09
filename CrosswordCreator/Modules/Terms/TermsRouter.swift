//
//  TermsRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol TermsRouterProtocol {
    
    func wantsToGoBack()
    func wantsToOpen(with inputVC: RecentsModuleOutput)
}

final class TermsRouter: TermsRouterProtocol {
    
    private weak var transitionHandler: ViewTransitionHandler?
    
    init(transitionHandler: ViewTransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToGoBack() {
        transitionHandler?.dismiss()
    }
    
    func wantsToOpen(with inputVC: RecentsModuleOutput) {
        let vc = RecentsBuilder.viewController(with: .picker, moduleOutput: inputVC)
        if let nvc = vc.navigationController {
            transitionHandler?.present(nvc)
        }
    }
}
