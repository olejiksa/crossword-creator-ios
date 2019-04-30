//
//  FillAlertController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 19/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol FillAlertControllerDelegate: class {
    
    func fill(with answer: String, index: Int, maxLength: Int)
}

final class FillAlertController: UIAlertController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let question = "word_question".localized
        static let answer = "questions_answer".localized
        static let ok = "OK"
        static let cancel = "cancel".localized
    }
    
    
    // MARK: Public Properties
    
    weak var delegate: FillAlertControllerDelegate?
    
    
    // MARK: Private Properties
    
    private var index: Int?
    private var maxLength: Int?
    private var enteredAnswer: String?
    
    
    // MARK: Public
    
    static func create(with filledWord: FilledWord) -> FillAlertController {
        let message = filledWord.word.question
        
        let fillAlertController = FillAlertController(title: Constants.question,
                                                      message: message,
                                                      preferredStyle: .alert)
        fillAlertController.setup(with: filledWord)
        return fillAlertController
    }
    
    
    // MARK: Private
    
    private func setup(with filledWord: FilledWord) {
        index = filledWord.index
        maxLength = filledWord.word.answer.count
        enteredAnswer = filledWord.enteredAnswer
        
        addTextField { [weak self] answerTextField in
            guard let strongSelf = self else { return }
            
            answerTextField.delegate = self
            answerTextField.placeholder = Constants.answer
            answerTextField.addTarget(self,
                                      action: #selector(strongSelf.textFieldDidChange),
                                      for: .editingChanged)
            
            answerTextField.text = filledWord.enteredAnswer
        }
        
        let okAction = UIAlertAction(title: Constants.ok, style: .default) { [weak self] _ in
            guard
                let strongSelf = self,
                let answer = strongSelf.textFields?[0].text, let index = self?.index,
                let maxLength = strongSelf.maxLength
            else { return }
            
            let trimmedAnswer = answer.trimmingCharacters(in: .whitespaces)
            let lowercasedAnswer = trimmedAnswer.lowercased()
            
            self?.delegate?.fill(with: lowercasedAnswer,
                                 index: index,
                                 maxLength: maxLength)
        }
        addAction(okAction)
        
        let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel)
        addAction(cancelAction)
        
        okAction.isEnabled = false
    }
    
    @objc private func textFieldDidChange() {
        guard
            let textField = textFields?[0],
            let text = textField.text
        else { return }
        
        let enteredAnswer = self.enteredAnswer ?? ""
        
        let okAction = actions[0]
        okAction.isEnabled = text != enteredAnswer
    }
}




// MARK: - UITextFieldDelegate

extension FillAlertController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard
            let maxLength = maxLength,
            let currentString = textField.text,
            let range = Range(range, in: currentString)
        else { return false }
        
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
}
