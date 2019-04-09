//
//  FillViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class FillViewController: UIViewController {

    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "Fill"
    }
    
    
    // MARK: Private Properties
    
    private let dataSource: FillDataSource
    private let xmlService: XmlServiceProtocol
    private let gridTitle: String
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var questionsButton: UIBarButtonItem!
    @IBOutlet private weak var checkButton: UIToolbar!
    
    // MARK: Public Properties
    
    var router: FillRouterProtocol?
    
    
    
    
    // MARK: Lifecycle
    
    init(dataSource: FillDataSource,
         title: String) {
        self.dataSource = dataSource
        self.xmlService = XmlService()
        self.gridTitle = title
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    // MARK: Private
    
    private func setupView() {
        collectionView.collectionViewLayout = NodeLayout(itemWidth: 50, itemHeight: 50, space: 1)
        dataSource.setup(with: collectionView)
        
        setupNavigationBar()
        
        collectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(willCancel))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(willShare))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItems = [shareButton]
    }
    
    @objc private func willCancel() {
        router?.wantsToGoBack()
    }
    
    @objc private func willShare() {
        router?.wantsToShare(with: gridTitle, view: view, layoutWords: dataSource.words)
    }
    
    @IBAction private func seeQuestions(_ sender: UIBarButtonItem) {
        router?.wantsToSeeQuestions(with: dataSource.words)
    }
    
    @IBAction private func check(_ sender: UIBarButtonItem) {
        AlertsFactory.crosswordIsFilledIncorrectly(self)
    }
}




// MARK: - UICollectionViewDelegate

extension FillViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let letter = dataSource.charGrid[indexPath.section][indexPath.row]
        
        if let word = letter.word, let index = letter.index {
            let filledWord: FilledWord
            filledWord.index = index
            filledWord.word = Word(question: word.question, answer: word.answer)
            filledWord.enteredAnswer = dataSource.enteredAnswers[index]
            
            router?.wantsToFill(with: filledWord)
        }
    }
}




extension FillViewController: FillAlertControllerDelegate {
    
    func fill(with answer: String, index: Int) {
        dataSource.enteredAnswers[index] = answer
        
        for i in 0..<dataSource.charGrid.count {
            for j in 0..<dataSource.charGrid[i].count {
                if dataSource.charGrid[i][j].index == index, j < answer.count {
                    dataSource.charGrid[i][j].value = String(answer[j])
                }
            }
        }
        
        collectionView.reloadData()
    }
}
