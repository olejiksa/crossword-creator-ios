//
//  RecentsCell.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 15/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RecentsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstSubtitle: UILabel!
    @IBOutlet weak var secondSubtitle: UILabel!    
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
