//
//  Table+Empty.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setupEmptyView(with text: String) {
        let origin = CGPoint(x: 0, y: 0)
        let width = bounds.size.width
        let height = bounds.size.height
        let size = CGSize(width: width, height: height - 10)
        let rectangle = CGRect(origin: origin, size: size)
        
        let noItemsLabel = UILabel(frame: rectangle)
        noItemsLabel.text = text
        noItemsLabel.textColor = .gray
        noItemsLabel.numberOfLines = 0
        noItemsLabel.textAlignment = .center
        noItemsLabel.sizeToFit()
        
        backgroundView = noItemsLabel
        separatorStyle = .none
    }
    
    func restore() {
        backgroundView = nil
        separatorStyle = .none
    }
}
