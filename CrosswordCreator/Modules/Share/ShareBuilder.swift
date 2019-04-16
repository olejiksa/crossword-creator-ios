//
//  ShareBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 19/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ShareBuilder {
    
    enum WordType {
        
        case listWords([Word])
        case gridWords([LayoutWord])
    }
    
    private static var documentsDirectory: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func viewController(with title: String,
                               wordType: WordType) -> UIActivityViewController {
        let fileExtension: FileExtension
        switch wordType {
        case .listWords(_):
            fileExtension = .list
            
        case .gridWords(_):
            fileExtension = .grid
        }
        
        let name = "\(title).\(fileExtension.rawValue)"
        let fileURL = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(name)
        
        let xmlService = ServiceLocator.xmlService
        
        let xml: String
        switch wordType {
        case .listWords(let words):
            xml = xmlService.writeList(with: words)
        
        case .gridWords(let layoutWords):
            xml = xmlService.writeGrid(with: layoutWords)
        }
        
        try? xml.write(to: fileURL, atomically: true, encoding: .utf8)
        let activityViewController = UIActivityViewController(activityItems: [fileURL],
                                                              applicationActivities: nil)
        
        return activityViewController
    }
}
