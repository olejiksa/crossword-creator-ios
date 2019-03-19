//
//  ShareBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 19/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ShareBuilder {
    
    private static let xmlService: XmlServiceProtocol = XmlService()
    
    private static var documentsDirectory: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func viewController(with title: String,
                               words: [Word]) -> UIActivityViewController? {
        let fileExtension = FileExtension.list.rawValue
        let name = "\(title).\(fileExtension)"
        
        do {
            let fileURL = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(name)
            let xml = xmlService.writeList(with: words)
            try xml.write(to: fileURL, atomically: true, encoding: .utf8)
            
            let activityViewController = UIActivityViewController(activityItems: [fileURL],
                                                                  applicationActivities: nil)
            
            return activityViewController
        } catch {
            return nil
        }
    }
    
    static func viewController(with title: String,
                               layoutWords: [LayoutWord]) -> UIActivityViewController? {
        let fileExtension = FileExtension.grid.rawValue
        let name = "\(title).\(fileExtension)"
        
        do {
            let fileURL = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(name)
            let xml = xmlService.writeGrid(with: layoutWords)
            try xml.write(to: fileURL, atomically: true, encoding: .utf8)
            
            let activityViewController = UIActivityViewController(activityItems: [fileURL],
                                                      applicationActivities: nil)
            
            return activityViewController
        } catch {
            return nil
        }
    }
}
