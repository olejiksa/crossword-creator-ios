//
//  GridViewCell.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 23/01/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class GridViewCell: UICollectionViewCell {

    enum CellType {
        case white, black(String), indexed(String)
    }
    
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var letter: UILabel!
    
    var cellType: CellType = .white
    
    func setup(with type: CellType) {
        cellType = type
        
        switch type {
        case .white:
            letter.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            view.backgroundColor = .lightText
            letter.textColor = .clear
            
        case .black(let char):
            view.backgroundColor = .white
            letter.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            letter.text = char.uppercased()
            letter.textColor = .black
            
        case .indexed(var char):
            view.backgroundColor = .white
            letter.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            _ = char.removeLast()
            letter.text = char
            letter.textColor = .black
        }
    }
}
