//
//  Word.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 29/10/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

struct Word {
    
    let question: String
    let answer: String
}

typealias OrderedWord = (word: Word, index: Int)
