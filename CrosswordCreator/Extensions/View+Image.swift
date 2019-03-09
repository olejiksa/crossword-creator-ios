//
//  View+Image.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 03/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func toImage() -> UIImage? {
        let currentSize = frame.size
        let currentOffset = contentOffset
        
        frame.size = contentSize
        setContentOffset(.zero, animated: false)
        
        // it might need a delay here to allow loading data.
        
        let rect = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        frame.size = currentSize
        setContentOffset(currentOffset, animated: false)
        
        return resizeUIImage(image!, scale: 10)
    }
    
    private func resizeUIImage(_ image: UIImage, scale: CGFloat) -> UIImage {
        
        let size = image.size
        
        let targetSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
