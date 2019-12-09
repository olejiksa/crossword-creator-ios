//
//  RollDelegate.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

protocol RollDelegate: class {
    
    func openFillDialog(with word: LayoutWord, by index: Int)
}
