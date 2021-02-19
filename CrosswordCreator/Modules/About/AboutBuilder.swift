//
//  AboutBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AboutBuilder {
    
    static func viewController(transitionHandler: ViewTransitionHandler?) -> AboutViewController {
        let presenter = AboutPresenter()
        let vc = AboutViewController(presenter: presenter)
        let router = AboutRouter(transitionHandler: transitionHandler)
        vc.router = router
        return vc
    }
}
