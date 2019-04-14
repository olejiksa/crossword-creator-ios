//
//  String+Subscript.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 03/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

extension String {
    
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start..<end])
    }
}
