//
//  NewRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 03/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol NewRouterProtocol {
    
    func wantsToOpenListEditor()
    func wantsToOpenListEditor(_ action: UIAlertAction)
    
    func wantsToOpenGridEditor()
    func wantsToOpenGridEditor(_ action: UIAlertAction)
}

final class NewRouter: NewRouterProtocol {
    
    private weak var transitionHandler: ViewTransitionHandler?
    
    init(transitionHandler: ViewTransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToOpenListEditor() {
        let listViewController = ListBuilder.viewController()
        if let nvc = listViewController.navigationController {
            transitionHandler?.present(nvc)
        }
    }
    
    func wantsToOpenListEditor(_ action: UIAlertAction) {
        wantsToOpenListEditor()
    }
    
    func wantsToOpenGridEditor() {
        let termsViewController = TermsBuilder.viewController()
        if let navigationController = termsViewController.navigationController {
            transitionHandler?.present(navigationController)
        }
    }
    
    func wantsToOpenGridEditor(_ action: UIAlertAction) {
        wantsToOpenGridEditor()
    }
}
