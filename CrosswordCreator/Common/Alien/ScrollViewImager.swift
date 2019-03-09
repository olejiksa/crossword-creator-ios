//
//  ScrollViewImager.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 03/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollViewImager {
    
    var bounds: CGRect { get }
    var contentSize: CGSize { get }
    var contentOffset: CGPoint { get }
    
    func setContentOffset(_ contentOffset: CGPoint, animated: Bool)
    func drawHierarchy(in rect: CGRect, afterScreenUpdates: Bool) -> Bool
}

extension ScrollViewImager {
    
    func screenshot(completion: @escaping (_ screenshot: UIImage) -> Void) {
        
        let pointsAndFrames = getScreenshotRects()
        let points = pointsAndFrames.points
        let frames = pointsAndFrames.frames
        
        makeScreenshots(points: points, frames: frames) { (screenshots) -> Void in
            let stitched = self.stitchImages(images: screenshots, finalSize: self.contentSize)
            completion(stitched!)
        }
        
    }
    
    private func makeScreenshots(points:[[CGPoint]], frames : [[CGRect]],completion: @escaping (_ screenshots: [[UIImage]]) -> Void) {
        
        var counter : Int = 0
        
        var images : [[UIImage]] = [] {
            didSet {
                if counter < points.count {
                    makeScreenshotRow(points: points[counter], frames : frames[counter]) { (screenshot) -> Void in
                        counter += 1
                        images.append(screenshot)
                    }
                } else {
                    completion(images)
                }
            }
        }
        
        makeScreenshotRow(points: points[counter], frames : frames[counter]) { (screenshot) -> Void in
            counter += 1
            images.append(screenshot)
        }
        
    }
    
    private func makeScreenshotRow(points:[CGPoint], frames : [CGRect],completion: @escaping (_ screenshots: [UIImage]) -> Void) {
        
        var counter : Int = 0
        
        var images : [UIImage] = [] {
            didSet {
                if counter < points.count {
                    takeScreenshotAtPoint(point: points[counter]) { (screenshot) -> Void in
                        counter += 1
                        images.append(screenshot)
                    }
                } else {
                    completion(images)
                }
            }
        }
        
        takeScreenshotAtPoint(point: points[counter]) { (screenshot) -> Void in
            counter += 1
            images.append(screenshot)
        }
        
    }
    
    private func getScreenshotRects() -> (points:[[CGPoint]], frames:[[CGRect]]) {
        
        let vanillaBounds = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        
        let xPartial = contentSize.width.truncatingRemainder(dividingBy: bounds.size.width)
        let yPartial = contentSize.height.truncatingRemainder(dividingBy: bounds.size.height)
        
        let xSlices = Int((contentSize.width - xPartial) / bounds.size.width)
        let ySlices = Int((contentSize.height - yPartial) / bounds.size.height)
        
        var currentOffset = CGPoint(x: 0, y: 0)
        
        var offsets : [[CGPoint]] = []
        var rects : [[CGRect]] = []
        
        var xSlicesWithPartial : Int = xSlices
        
        if xPartial > 0 {
            xSlicesWithPartial += 1
        }
        
        var ySlicesWithPartial : Int = ySlices
        
        if yPartial > 0 {
            ySlicesWithPartial += 1
        }
        
        for y in 0..<ySlicesWithPartial {
            
            var offsetRow : [CGPoint] = []
            var rectRow : [CGRect] = []
            currentOffset.x = 0
            
            for x in 0..<xSlicesWithPartial {
                
                if y == ySlices && x == xSlices {
                    let rect = CGRect(x: bounds.width - xPartial, y: bounds.height - yPartial, width: xPartial, height: yPartial)
                    rectRow.append(rect)
                    
                } else if y == ySlices {
                    let rect = CGRect(x: 0, y: bounds.height - yPartial, width: bounds.width, height: yPartial)
                    rectRow.append(rect)
                    
                } else if x == xSlices {
                    let rect = CGRect(x: bounds.width - xPartial, y: 0, width: xPartial, height: bounds.height)
                    rectRow.append(rect)
                    
                } else {
                    rectRow.append(vanillaBounds)
                }
                
                offsetRow.append(currentOffset)
                
                if x == xSlices {
                    currentOffset.x = contentSize.width - bounds.size.width
                } else {
                    currentOffset.x = currentOffset.x + bounds.size.width
                }
            }
            if y == ySlices {
                currentOffset.y = contentSize.height - bounds.size.height
            } else {
                currentOffset.y = currentOffset.y + bounds.size.height
            }
            
            offsets.append(offsetRow)
            rects.append(rectRow)
            
        }
        
        return (points:offsets, frames:rects)
        
    }
    
    private func takeScreenshotAtPoint(point point_I: CGPoint, completion: @escaping (_ screenshot: UIImage) -> Void) {
        let rect = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        let currentOffset = contentOffset
        setContentOffset(point_I, animated: false)
        
        delay(delay: 0.001) {
            
            UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
            let _ = self.drawHierarchy(in: rect, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            self.setContentOffset(currentOffset, animated: false)
            completion(image!)
        }
    }
    
    private func delay(delay:Double, closure: @escaping ()->()) {
        let dtime = DispatchTime.now() + delay * Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dtime, execute: closure)
    }
    
    
    private func crop(image image_I:UIImage, toRect rect:CGRect) -> UIImage? {
        guard let imageRef: CGImage = image_I.cgImage!.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage:imageRef)
    }
    
    private func stitchImages(images images_I: [[UIImage]], finalSize : CGSize) -> UIImage? {
        
        let finalRect = CGRect(x: 0, y: 0, width: finalSize.width, height: finalSize.height)
        
        guard images_I.count > 0 else {
            return nil
        }
        
        UIGraphicsBeginImageContext(finalRect.size)
        
        var offsetY : CGFloat = 0
        
        for imageRow in images_I {
            
            var offsetX : CGFloat = 0
            
            for image in imageRow {
                
                let width = image.size.width
                let height = image.size.height
                
                
                let rect = CGRect(x: offsetX, y: offsetY, width: width, height: height)
                image.draw(in: rect)
                
                offsetX += width
                
            }
            
            offsetX = 0
            
            if let firstimage = imageRow.first {
                offsetY += firstimage.size.height
            } // maybe add error handling here
        }
        
        let stitchedImages = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return stitchedImages
    }
}

extension UIScrollView : ScrollViewImager {
    
}
