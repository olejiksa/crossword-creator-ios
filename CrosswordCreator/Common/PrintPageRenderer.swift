//
//  ImagePageRenderer.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 16/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import AVFoundation
import UIKit

final class ImagePageRenderer: UIPrintPageRenderer {
    
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init()
        
        let imageView = UIImageView(image: image)
        let formatter = imageView.viewPrintFormatter()
        
        formatter.perPageContentInsets = UIEdgeInsets.zero
        
        addPrintFormatter(formatter, startingAtPageAt: 0)
    }
}
