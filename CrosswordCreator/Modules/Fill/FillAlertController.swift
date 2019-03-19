//
//  FillAlertController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 19/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class FillAlertController: UIAlertController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let question = "Question"
        static let answer = "Your answer"
        static let ok = "OK"
        static let cancel = "Cancel"
    }
    
    
    // MARK: Private Properties
    
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
            // unused
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
