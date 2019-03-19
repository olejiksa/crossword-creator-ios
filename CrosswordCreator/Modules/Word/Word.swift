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
typealias FilledWord = (word: Word, index: Int, enteredAnswer: String?)

struct LayoutWord {
    
    enum Direction: String {
        
        case vertical = "Vertical"
        case horizontal = "Horizontal"
    }
    
    var question = ""
    var answer = ""
    var column = 0
    var row = 0
    var direction: Direction = .horizontal
    
    init(question: String,
         answer: String,
         column: Int,
         row: Int,
         direction: Direction) {
        self.question = question
        self.answer = answer
        self.column = column
        self.row = row
        self.direction = direction
    }
}
