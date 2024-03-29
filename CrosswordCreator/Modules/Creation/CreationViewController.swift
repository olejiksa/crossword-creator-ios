//
//  CreationViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 14/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class CreationViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var fillAllSwitch: UISwitch!
    @IBOutlet private weak var nextButton: UIBarButtonItem!
    @IBOutlet private weak var missedWordsLabel: UILabel!
    @IBOutlet private weak var columnsCountLabel: UILabel!
    @IBOutlet private weak var rowsCountLabel: UILabel!
    
    
    // MARK: Public Properties
    
    var words: [Word] = []
    var router: CreationRouterProtocol?
    
    
    // MARK: Private Properties
    
    private var layoutWords: [LayoutWord] = []
    private var columnsCount = 128 {
        didSet {
            columnsCountLabel?.text = String(columnsCount)
        }
    }
    private var rowsCount = 128 {
        didSet {
            rowsCountLabel?.text = String(rowsCount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    
    // MARK: Private
    
    private func setupView() {
        setupNavigationBar()
        missedWordsLabel?.text = ""
    }
    
    private func setupNavigationBar() {
        title = "Grid Creation"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction private func willGenerate(_ sender: UIBarButtonItem) {
        let generator = CrosswordsGenerator(columns: columnsCount,
                                            rows: rowsCount,
                                            words: words.map { ($0.question, $0.answer) })
        
        generator.fillAllWords = fillAllSwitch.isOn
        generator.orientationOptimization = false
        generator.generate()
        
        layoutWords = generator.result
        let plainWordsFromLayout = layoutWords.map { Word(question: $0.question, answer: $0.answer) }
        
        let intersected = plainWordsFromLayout.difference(from: words)
        
        if !intersected.isEmpty {
            missedWordsLabel?.text = "Missed words:"
            intersected.forEach {
                self.missedWordsLabel.text = (self.missedWordsLabel.text ?? "") + " " + $0.answer + ","
            }
            let unwrapped = missedWordsLabel?.text ?? ""
            missedWordsLabel?.text = unwrapped[0..<unwrapped.count-1]
        } else {
            missedWordsLabel?.text = ""
        }
        
        nextButton.isEnabled = true
    }
    
    @IBAction private func willNext(_ sender: UIBarButtonItem) {
        router?.wantsToNext(with: layoutWords)
    }
    
    @IBAction private func didColumnsCountChange(_ sender: UISlider) {
        columnsCount = Int(sender.value)
    }
    
    @IBAction private func didRowsCountChange(_ sender: UISlider) {
        rowsCount = Int(sender.value)
    }
}
