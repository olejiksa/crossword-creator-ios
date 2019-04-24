//
//  RecentsRouter.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 15/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol RecentsRouterProtocol {
    
    func wantsToOpenListEditor(with title: String, words: [Word], index: Int)
    func wantsToFill(with title: String, words: [LayoutWord], index: Int)
    func wantsToCreate(with viewController: UIViewController, superview: UIView)
    func wantsToGoBack()
}

final class RecentsRouter: RecentsRouterProtocol {
    
    private weak var transitionHandler: ViewTransitionHandler?
    
    init(transitionHandler: ViewTransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func wantsToOpenListEditor(with title: String, words: [Word], index: Int) {
        let vc = ListBuilder.viewController(with: title, words: words)
        vc.index = index
        
        if let nvc = vc.navigationController {
            nvc.setToolbarHidden(false, animated: true)
            nvc.setNavigationBarHidden(false, animated: true)
            
            transitionHandler?.present(nvc)
        }
    }
    
    func wantsToFill(with title: String, words: [LayoutWord], index: Int) {
        let vc = FillBuilder.viewController(with: title, words: words)
        vc.index = index
        
        if let nvc = vc.navigationController {
            nvc.setToolbarHidden(false, animated: true)
            nvc.setNavigationBarHidden(false, animated: true)
            
            transitionHandler?.present(nvc)
        }
    }
    
    func wantsToCreate(with viewController: UIViewController,
                       superview: UIView) {
        let ac = NewBuilder.alertController(with: viewController, superview: superview)
        transitionHandler?.present(ac)
    }
    
    func wantsToGoBack() {
        transitionHandler?.dismiss()
    }
}
