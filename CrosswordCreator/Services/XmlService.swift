//
//  XmlService.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

protocol XmlServiceProtocol {
    
    func readList(from url: URL) -> [Word]
    func readGrid(from url: URL) -> [LayoutWord]
    
    func writeList(with words: [Word]) -> String
    func writeGrid(with words: [LayoutWord]) -> String
}

final class XmlService {
    
    // MARK: Private Data Stuctures
    
    private enum Constants {
        
        static let head = "head"
        static let listWord = "word"
        static let gridWord = "gridWord"
        
        static let cellSize = 25
    }
    
    private enum Key: String {
        case id = "ID"
        case x = "X"
        case y = "Y"
        case orientation = "orientation"
        case answer = "answer"
        case question = "question"
    }
    
    private enum Value {
        case index(Int)
        case position(Int)
        case string(String)
        case orientation(LayoutWord.Direction)
    }
    
    
    // MARK: Private
    
    private func xmlElement(key: Key, value: Value) -> AEXMLElement {
        switch value {
        case .index(let number):
            return AEXMLElement(name: key.rawValue, value: String(number))
            
        case .position(let position):
            return AEXMLElement(name: key.rawValue, value: String(Constants.cellSize * position))
            
        case .string(let string):
            return AEXMLElement(name: key.rawValue, value: string)
            
        case .orientation(let orientation):
            return AEXMLElement(name: key.rawValue, value: orientation.rawValue)
        }
    }
}




// MARK: - XmlServiceProtocol

extension XmlService: XmlServiceProtocol {
    
    func readList(from url: URL) -> [Word] {
        let decoder = XMLDecoder()
        
        do {
            let data = try Data(contentsOf: url)
            let file = try decoder.decode(RAWListFile.self, from: data)
            let sortedRaws = file.word.sorted { $0.id < $1.id }
            return sortedRaws.map { Word(question: $0.question, answer: $0.answer) }
        } catch {
            return []
        }
    }
    
    func readGrid(from url: URL) -> [LayoutWord] {
        let decoder = XMLDecoder()
        
        do {
            let data = try Data(contentsOf: url)
            let file = try decoder.decode(RAWGridFile.self, from: data)
            let sortedRaws = file.gridWord.sorted { $0.id < $1.id }
            return sortedRaws.map { // refactor!
                return LayoutWord(question: $0.question,
                                  answer: $0.answer,
                                  column: ($0.x / Constants.cellSize) - 1,
                                  row: ($0.y / Constants.cellSize) - 1,
                                  direction: $0.orientation == LayoutWord.Direction.vertical.rawValue ? .vertical : .horizontal)
            }
        } catch {
            return []
        }
    }
    
    func writeList(with words: [Word]) -> String {
        let document = AEXMLDocument()
        let head = AEXMLElement(name: Constants.head)
        document.addChild(head)
        
        for (index, word) in words.enumerated() {
            let listWord = AEXMLElement(name: Constants.listWord)
            
            let id = xmlElement(key: .id, value: .index(index))
            let answer = xmlElement(key: .answer, value: .string(word.answer))
            let question = xmlElement(key: .question, value: .string(word.question))
            
            listWord.addChildren([id, answer, question])
            
            head.addChild(listWord)
        }
        
        return document.xml
    }
    
    func writeGrid(with words: [LayoutWord]) -> String {
        let document = AEXMLDocument()
        let head = AEXMLElement(name: Constants.head)
        document.addChild(head)
        
        for (index, word) in words.enumerated() {
            let gridWord = AEXMLElement(name: Constants.gridWord)
            
            let id = xmlElement(key: .id, value: .index(index))
            let x = xmlElement(key: .x, value: .position(word.column))
            let y = xmlElement(key: Key.y, value: .position(word.row))
            let orientation = xmlElement(key: .orientation, value: .orientation(word.direction))
            let answer = xmlElement(key: .answer, value: .string(word.answer))
            let question = xmlElement(key: .question, value: .string(word.question))
            
            gridWord.addChildren([id, x, y, orientation, answer, question])
            
            head.addChild(gridWord)
        }
        
        return document.xml
    }
}
