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
         xmlService: XmlServiceProtocol,
         title: String) {
        self.dataSource = dataSource
        self.xmlService = xmlService
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
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(didReceivePinchGesture(_:)))
        collectionView.addGestureRecognizer(gesture)
        
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
        let validAnswers = dataSource.words.map { $0.answer }
        let enteredAnswers = dataSource.enteredAnswers
        
        let isValid = validAnswers == enteredAnswers
        
        if !isValid {
            AlertsFactory.crosswordIsFilledIncorrectly(self)
        } else {
            AlertsFactory.crosswordIsFilledCorrectly(self)
        }
    }
    
    @objc private func didReceivePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            dataSource.scaleStart = dataSource.scale
            
        case .changed:
            dataSource.scale = dataSource.scaleStart * gesture.scale
            collectionView?.collectionViewLayout.invalidateLayout()
            
        default:
            break
        }
    }
}




// MARK: - UICollectionViewDelegate

extension FillViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let letter = dataSource.charGrid[indexPath.section][indexPath.row]
        
        if let word = letter.word, let index = letter.indexes.last {
            let filledWord: FilledWord
            filledWord.index = index
            filledWord.word = Word(question: word.question, answer: word.answer)
            filledWord.enteredAnswer = dataSource.enteredAnswers[index]
            
            router?.wantsToFill(with: filledWord)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50 * dataSource.scale, height: 50 * dataSource.scale)
    }
}




extension FillViewController: FillAlertControllerDelegate {
    
    func fill(with answer: String, index: Int, maxLength: Int) {
        dataSource.enteredAnswers[index] = answer
        
        var answerToFill = answer
        (1...maxLength).forEach { _ in
            answerToFill += " "
        }
        
        var ind = -1
        
        for i in 0..<dataSource.charGrid.count {
            for j in 0..<dataSource.charGrid[i].count {
                if dataSource.charGrid[i][j].indexes.count > 0,
                   dataSource.charGrid[i][j].indexes.contains(index), ind < answerToFill.count {
                    
                    if ind < 0 {
                        ind += 1
                        continue
                    } else {
                        dataSource.charGrid[i][j].value = String(answerToFill[ind])
                        ind += 1
                    }
                    
                    collectionView.reloadItems(at: [IndexPath(row: j, section: i)])
                }
            }
        }
    }
}
