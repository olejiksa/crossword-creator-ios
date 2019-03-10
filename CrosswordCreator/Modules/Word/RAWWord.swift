//
//  RAWWord.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

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
