//
//  RAWWord.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

struct Word: Hashable {
    
    let question: String
    let answer: String
}

typealias OrderedWord = (word: Word, index: Int)
typealias FilledWord = (word: Word, index: Int, enteredAnswer: String?)

struct LayoutWord: Equatable {
    
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

struct RAWListFile: Codable {
    
    let word: [RAWListWord]
}

struct RAWListWord: Codable {
    
    let id: Int
    let answer: String
    let question: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case answer = "answer"
        case question = "question"
    }
}

struct RAWGridFile: Codable {
    
    let gridWord: [RAWGridWord]
}

struct RAWGridWord: Codable {
    
    let id: Int
    let x: Int
    let y: Int
    let orientation: String
    let answer: String
    let question: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case x = "X"
        case y = "Y"
        case orientation = "orientation"
        case answer = "answer"
        case question = "question"
    }
}
