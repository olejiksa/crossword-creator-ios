//
//  String+IsEmptyOrWhitespace.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 29/10/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

extension String {
    
    var isEmptyOrWhitespace: Bool {
        return isEmpty ? true : trimmingCharacters(in: .whitespaces).isEmpty
    }
}
