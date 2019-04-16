//
//  SaveBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 16/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

final class SaveBuilder {
    
    static func alertController(with mode: SaveAlertController.Mode) -> SaveAlertController {
        return SaveAlertController.create(with: mode)
    }
}
