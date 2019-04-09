//
//  SubtitleTableViewCell.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 10/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SubtitleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
