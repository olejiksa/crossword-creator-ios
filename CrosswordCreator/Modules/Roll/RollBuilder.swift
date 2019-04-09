//
//  RollBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 10/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RollBuilder {
    
    static func viewController(with words: [LayoutWord],
                               mode: RollViewController.Mode) -> UIViewController {
        return RollViewController(with: words, mode: mode)
    }
}
