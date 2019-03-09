//
//  SaveAlertController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 16/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol SaveAlertControllerDelegate: class {
    
    func saveCrossword(with title: String)
}

final class SaveAlertController: UIAlertController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "Crossword"
        static let new = "Enter the title for a new crossword."
        static let ok = "OK"
        static let cancel = "Cancel"
    }
    
    
    // MARK: Public Properties
    
    weak var delegate: SaveAlertControllerDelegate?
    
    
    // MARK: Public
    
    static func create() -> SaveAlertController {
        let saveAlertController = SaveAlertController(title: Constants.title,
                                                      message: Constants.new,
                                                      preferredStyle: .alert)
        saveAlertController.setup()
        return saveAlertController
    }
    
    
    // MARK: Private
    
    private func setup() {
        addTextField { [weak self] questionTextField in
            guard let strongSelf = self else { return }
            
            questionTextField.placeholder = Constants.title
            questionTextField.addTarget(self,
                                        action: #selector(strongSelf.textFieldDidChange),
                                        for: .editingChanged)
        }
        
        let okAction = UIAlertAction(title: Constants.ok, style: .default) { [weak self] _ in
            guard
                let strongSelf = self,
                let title = strongSelf.textFields?[0].text,
                !title.isEmpty
            else { return }
            
            let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
            strongSelf.delegate?.saveCrossword(with: trimmedTitle)
        }
        addAction(okAction)
        
        let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil)
        addAction(cancelAction)
        
        okAction.isEnabled = false
    }
    
    @objc private func textFieldDidChange() {
        // TODO: Answer mustn't contain whitespace at all
        guard
            let titleTextField = textFields?[0],
            let isTitleEmpty = titleTextField.text?.isEmptyOrWhitespace
        else { return }
        
        let okAction = actions[0]
        okAction.isEnabled = !isTitleEmpty
    }
}
