//
//  String+Localized.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 01/05/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
