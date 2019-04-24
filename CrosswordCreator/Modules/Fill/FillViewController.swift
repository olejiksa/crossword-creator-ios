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
    private var scale: Float = 50.0
    
    
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
        
        let printButton = UIBarButtonItem(title: "Print", style: .plain, target: self, action: #selector(print))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(willShare))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItems = [shareButton, printButton]
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
            dataSource.badAnswers = dataSource.words.filter { !enteredAnswers.contains($0.answer) }
            AlertsFactory.crosswordIsFilledIncorrectly(self, yesAction: showMistakes)
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
    
    @IBAction func didZoomTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title:"Zoom",
                                                message: nil,
                                                preferredStyle: .alert)
        let slider = UISlider(frame: CGRect(x: 35, y: 50, width: 200, height: 20))
        slider.minimumValue = 25
        slider.maximumValue = 50
        slider.value = scale
        alertController.view.addSubview(slider)
        
        let height = NSLayoutConstraint(item: alertController.view as Any,
                                        attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1, constant: 140)
        alertController.view.addConstraint(height)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (error) -> Void in
            self.scale = slider.value
            let val = CGFloat(slider.value)
            self.collectionView.collectionViewLayout = NodeLayout(itemWidth: val,
                                                             itemHeight: val,
                                                             space: 1)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (error) -> Void in
            
        }))
        
        self.present(alertController)
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
