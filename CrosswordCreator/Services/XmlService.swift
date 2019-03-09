//
//  XmlService.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

protocol XmlServiceProtocol {
    
    func writeList(with words: [Word]) -> String
    func writeGrid(with words: [CrosswordsGenerator.Word]) -> String
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
        case orientation(CrosswordsGenerator.WordDirection)
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
            return AEXMLElement(name: key.rawValue, value: orientation.description)
        }
    }
}




// MARK: - XmlServiceProtocol

extension XmlService: XmlServiceProtocol {
    
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
    
    func writeGrid(with words: [CrosswordsGenerator.Word]) -> String {
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




// MARK: - CustomStringConvertible

extension CrosswordsGenerator.WordDirection: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .horizontal:
            return "Horizontal"
            
        case .vertical:
            return "Vertical"
        }
    }
}
