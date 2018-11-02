//
//  ListViewCell.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 25/10/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListViewCell: UITableViewCell {
    
    private(set) var word: Word?
    
    func setup(with word: Word) {
        self.word = word
        
        textLabel?.text = word.question
        detailTextLabel?.text = word.answer
    }
}
