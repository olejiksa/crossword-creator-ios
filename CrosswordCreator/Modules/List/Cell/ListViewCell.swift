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
        
        textLabel?.text = word.answer
        detailTextLabel?.text = word.question
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.lineBreakMode = .byWordWrapping
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.x += 10
            frame.size.width -= 2 * 10
            super.frame = frame
        }
    }
}
