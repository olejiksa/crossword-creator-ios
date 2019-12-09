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
        
        static let cancel = "cancel".localized
        static let title = "fill_title".localized
        static let questions = "questions".localized
        static let zoom = "zoom".localized
        static let check = "check".localized
    }
    
    
    // MARK: Private Properties
    
    private let dataSource: FillDataSource
    private let xmlService: XmlServiceProtocol
    private let gridTitle: String
    
    private var _scale: CGFloat = 1.0
    private var scale: CGFloat {
        get { return _scale }
        set(newScale) {
            if newScale < scaleBoundLower {
                _scale = scaleBoundLower
            } else if newScale > scaleBoundUpper {
                _scale = scaleBoundUpper
            } else {
                _scale = newScale
            }
        }
    }
    
    private var scaleStart: CGFloat = 0
    
    private let scaleBoundLower: CGFloat = 0.5
    private let scaleBoundUpper: CGFloat = 2
    
    private var gesture: UIPinchGestureRecognizer?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var questionsButton: UIBarButtonItem!
    @IBOutlet private weak var checkButton: UIToolbar!
    
    // MARK: Public Properties
    
    var router: FillRouterProtocol?
    
    var index: Int = 0
    
    
    
    override var previewActionItems: [UIPreviewActionItem] {
        let deleteAction = UIPreviewAction(title: "Delete", style: .destructive) { (action, viewController) -> Void in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let persistanceManager = appDelegate.persistanceManager
            
            let crosswords: [Crossword] = persistanceManager.fetch(entityName: "Crossword")
            persistanceManager.remove(crosswords[self.index])
            persistanceManager.save()
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTheTable"), object: nil)
        }
        
        return [deleteAction]
    }
    
    
    
    
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
        
        dataSource.setup(with: collectionView)
        
        setupNavigationBar()
        setupToolbar()
        
        collectionView.delegate = self
        
        gesture = UIPinchGestureRecognizer(target: self, action: #selector(didReceivePinchGesture))
        collectionView.addGestureRecognizer(gesture!)
    }
    
    private func setupNavigationBar() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(willCancel))
        
        let printButton = UIBarButtonItem(image: UIImage(systemName: "printer"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(print))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(willShare))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItems = [shareButton, printButton]
    }
    
    private func setupToolbar() {
        let questions = UIBarButtonItem(title: Constants.questions, style: .plain, target: self, action: #selector(seeQuestions))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let checkButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(self.check))
        
        toolbarItems = [questions, spacer, checkButton]
    }
    
    @objc private func willCancel() {
        router?.wantsToGoBack()
    }
    
    @objc private func willShare() {
        router?.wantsToShare(with: gridTitle, view: view, layoutWords: dataSource.words)
    }
    
    @objc private func seeQuestions() {
        router?.wantsToSeeQuestions(with: dataSource.words)
    }
    
    @objc private func check() {
        let validAnswers = dataSource.words.map { $0.answer }
        let enteredAnswers = dataSource.enteredAnswers
        
        let isValid = validAnswers == enteredAnswers
        
        if !isValid {
            dataSource.badAnswers = dataSource.words.filter { !enteredAnswers.contains($0.answer) }
            AlertsFactory.crosswordIsFilledIncorrectly(self, yesAction: showMistakes)
        } else {
            AlertsFactory.crosswordIsFilledCorrectly(self)
        }
    }
    
    func showMistakes() {
        let indexes: [IndexPath] = dataSource.badAnswers.reduce(into: [IndexPath](), { result, layoutWord in
            var innerIndexes = [IndexPath]()
            switch layoutWord.direction {
            case .horizontal:
                (0..<1).forEach { innerIndexes.append(IndexPath(row: layoutWord.column + $0, section: layoutWord.row)) }
                
            case .vertical:
                (0..<1).forEach { innerIndexes.append(IndexPath(row: layoutWord.column, section: layoutWord.row + $0)) }
            }
            
            result += innerIndexes
        })
        
        for indexPath in indexes {
            let cell = self.collectionView.cellForItem(at: indexPath)
            
            UIView.animate(withDuration: 3, delay: 0, options: .allowUserInteraction, animations: { cell?.backgroundColor = .red
                
            }, completion: { _ in
                UIView.animate(withDuration: 3, delay: 0, options: .allowUserInteraction, animations:
                    { cell?.backgroundColor = .lightGray })
            })
        }
    }
    
    @objc private func print() {
        if let screenshot = collectionView.screenshot() {
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = gridTitle
            printInfo.outputType = .general
            
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = false
            printController.printPageRenderer = ImagePageRenderer(image: screenshot)
            printController.printingItem = screenshot
            
            printController.present(from: collectionView.frame, in: collectionView, animated: true, completionHandler: nil)
        }
    }
    
    @objc private func didReceivePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            scaleStart = scale
            
        case .changed:
            scale = scaleStart * gesture.scale
            
            Swift.print(scale)
            (collectionView.collectionViewLayout as? NodeLayout)?.itemWidth = 50 * scale
            (collectionView.collectionViewLayout as? NodeLayout)?.itemHeight = 50 * scale
            collectionView.collectionViewLayout.invalidateLayout()
            
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
        return CGSize(width: (collectionViewLayout as! NodeLayout).itemWidth,
                      height: (collectionViewLayout as! NodeLayout).itemHeight)
    }
}




// MARK: - FillAlertControllerDelegate

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




// MARK: - RollDelegate

extension FillViewController: RollDelegate {
    
    func openFillDialog(with word: LayoutWord, by index: Int) {
        let filledWord: FilledWord
        filledWord.index = index
        filledWord.word = Word(question: word.question, answer: word.answer)
        filledWord.enteredAnswer = dataSource.enteredAnswers[index]
        
        router?.wantsToFill(with: filledWord)
    }
}
