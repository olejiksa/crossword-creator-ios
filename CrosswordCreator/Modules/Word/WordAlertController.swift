//
//  WordAlertController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 29/10/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol WordAlertControllerDelegate: class {
    
    func addWord(_ word: Word)
    func replaceWord(by newWord: Word, at index: Int)
}

final class WordAlertController: UIAlertController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        enum Messages {
            
            static let new = "Enter the question and the answer for a new word."
            static let existing = "Edit the question or the answer for an existing word."
        }
        
        static let title = "Word"
        static let question = "Question"
        static let answer = "Answer"
        static let ok = "OK"
        static let cancel = "Cancel"
    }
    
    
    // MARK: Public Properties
    
    weak var delegate: WordAlertControllerDelegate?
    
    
    // MARK: Public
    
    static func create(with word: OrderedWord? = nil) -> WordAlertController {
        let message = word == nil ? Constants.Messages.new : Constants.Messages.existing
        
        let wordAlertController = WordAlertController(title: Constants.title,
                                                      message: message,
                                                      preferredStyle: .alert)
        wordAlertController.setup(with: word)
        return wordAlertController
    }
    
    
    // MARK: Private
    
    private func setup(with oldWord: OrderedWord? = nil) {
        addTextField { [weak self] questionTextField in
            guard let strongSelf = self else { return }
            
            if let question = oldWord?.word.question {
                questionTextField.text = question
            }
            
            questionTextField.placeholder = Constants.question
            questionTextField.addTarget(self,
                                        action: #selector(strongSelf.textFieldDidChange),
                                        for: .editingChanged)
        }
        
        addTextField { [weak self] answerTextField in
            guard let strongSelf = self else { return }
            
            if let answer = oldWord?.word.answer {
                answerTextField.text = answer
            }
            
            answerTextField.placeholder = Constants.answer
            answerTextField.addTarget(self,
                                      action: #selector(strongSelf.textFieldDidChange),
                                      for: .editingChanged)
        }
        
        let okAction = UIAlertAction(title: Constants.ok, style: .default) { [weak self] _ in
            guard
                let strongSelf = self,
                let question = strongSelf.textFields?[0].text,
                let answer = strongSelf.textFields?[1].text,
                !question.isEmpty,
                !answer.isEmpty
            else { return }
            
            let trimmedQuestion = question.trimmingCharacters(in: .whitespaces)
            let trimmedAnswer = answer.trimmingCharacters(in: .whitespaces)
            
            let newWord = Word(question: trimmedQuestion, answer: trimmedAnswer.lowercased())
            
            if oldWord != nil, let index = oldWord?.index {
                strongSelf.delegate?.replaceWord(by: newWord, at: index)
            } else {
                strongSelf.delegate?.addWord(newWord)
            }
        }
        addAction(okAction)
        
        let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel)
        addAction(cancelAction)
        
        okAction.isEnabled = oldWord != nil
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard
            let questionTextField = textFields?[0],
            let answerTextField = textFields?[1],
            let isQuestionEmpty = questionTextField.text?.isEmptyOrWhitespace,
            let answer = answerTextField.text
        else { return }
        
        let answerIsValid = !answer.isEmpty && !answer.contains(" ")
        
        let okAction = actions[0]
        okAction.isEnabled = !isQuestionEmpty && answerIsValid
    }
}
