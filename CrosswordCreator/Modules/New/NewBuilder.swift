//
//  NewBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class NewBuilder {
    
    static func alertController(with transitionHandler: ViewTransitionHandler) -> NewAlertController {
        let router = NewRouter(transitionHandler: transitionHandler)
        let alertController = NewAlertController.create(with: router)
        return alertController
    }
}
