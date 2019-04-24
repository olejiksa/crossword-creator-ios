//
//  UIScrollView+Image.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 16/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func screenshot() -> UIImage? {
        isScrollEnabled = false
        
        let savedContentOffset = contentOffset
        let savedFrame = frame
        
        UIGraphicsBeginImageContext(contentSize)
        contentOffset = .zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        contentOffset = savedContentOffset
        frame = savedFrame
        
        isScrollEnabled = true
        
        return image
    }
}
