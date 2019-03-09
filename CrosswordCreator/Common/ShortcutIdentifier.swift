//
//  ShortcutIdentifier.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

enum ShortcutIdentifier: String {
    
    case new
    
    
    // MARK: Public Properties
    
    var type: String {
        return Bundle.main.bundleIdentifier! + ".\(rawValue)"
    }
    
    
    
    
    // MARK: Lifecycle
    
    init?(fullNameForType: String) {
        guard let last = fullNameForType.components(separatedBy: ".").last else {
            return nil
        }
        
        self.init(rawValue: last)
    }
}
