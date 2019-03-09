//
//  String+Subscript.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 03/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
