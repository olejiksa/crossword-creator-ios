//
//  GridViewCell.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 23/01/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

class GridViewCell: UICollectionViewCell {

    enum CellType {
        
        case white, black(Character), indexed
    }
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var letter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with type: CellType) {
        switch type {
        case .white, .indexed:
            view.backgroundColor = .black
            
        case .black(let char):
            view.backgroundColor = .white
            letter.text = String(char).uppercased()
        }
    }
}
