//
//  WordViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 14/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol WordViewControllerDelegate: class {
    
    func addWord(_ word: Word)
    func replaceWord(by newWord: Word, at index: Int)
}

final class WordViewController: UIViewController {

    // MARK: Private Data Structures
    
    private enum Constants {
        static let title = "word_title".localized
        static let question = "word_question".localized
        static let answer = "word_answer".localized
    }
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var questionHeader: UILabel!
    @IBOutlet private weak var answerHeader: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var questionTextView: UITextView!
    @IBOutlet private weak var answerTextField: UITextField!
    
    
    // MARK: Public Properties
    
    weak var delegate: WordViewControllerDelegate?
    
    
    // MARK: Private Properties
    
    private let word: OrderedWord?
    
    
    
    
    // MARK: Lifecycle
    
    init(_ word: OrderedWord? = nil) {
        self.word = word
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        setupView()
    }
    
    
    // MARK: Private
    
    private func setupView() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(willDone))
        
        navigationItem.rightBarButtonItem = doneButton
        
        setupQuesiton()
        setupAnswer()
        
        doneButton.isEnabled = false
        
        questionTextView.becomeFirstResponder()
    }
    
    @objc private func willDone() {
        guard
            let question = questionTextView?.text,
            let answer = answerTextField?.text,
            !question.isEmpty,
            !answer.isEmpty
        else { return }
        
        let trimmedQuestion = question.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespaces)
        
        let newWord = Word(question: trimmedQuestion, answer: trimmedAnswer.lowercased())
        
        if word != nil, let index = word?.index {
            delegate?.replaceWord(by: newWord, at: index)
        } else {
            delegate?.addWord(newWord)
        }
        
        navigationController?.pop()
    }
    
    @objc private func textFieldDidChange() {
        textDidChange()
    }
    
    private func textDidChange() {
        guard
            let isQuestionEmpty = questionTextView.text?.isEmptyOrWhitespace,
            let answer = answerTextField.text
        else { return }
        
        let answerIsValid = !answer.isEmpty && !answer.contains(" ")
        
        navigationItem.rightBarButtonItem?.isEnabled = !isQuestionEmpty && answerIsValid
    }
    
    private func setupQuesiton() {
        questionHeader.text = Constants.question
        questionTextView.layer.cornerRadius = 5
        questionTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        questionTextView.layer.borderWidth = 0.5
        questionTextView.clipsToBounds = true
        questionTextView.text = word?.word.question
        questionTextView.delegate = self
    }
    
    private func setupAnswer() {
        answerHeader.text = Constants.answer
        answerTextField.layer.cornerRadius = 5
        answerTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        answerTextField.layer.borderWidth = 0.5
        answerTextField.text = word?.word.answer
        answerTextField.addTarget(self,
                                  action: #selector(textFieldDidChange),
                                  for: .editingChanged)
    }
}




extension WordViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textDidChange()
    }
}
