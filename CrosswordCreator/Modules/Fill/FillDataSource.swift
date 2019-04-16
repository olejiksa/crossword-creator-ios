//
//  FillDataSource.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol FillDataSourceProtocol {
    
    var charGrid: [[FillDataSource.Letter]] { get }
    var words: [LayoutWord] { get }
    var enteredAnswers: [String] { get }
    
    func setup(with: UICollectionView)
}

final class FillDataSource: NSObject, FillDataSourceProtocol {
    
    private enum Constants {
        
        static let cellIdentifier = "GridViewCell"
    }
    
    struct Letter {
        
        var indexes: [Int] = []
        var value: String
        var word: LayoutWord?
        
        init(value: String) {
            self.value = value
        }
    }
    
    private var size: (columns: Int, rows: Int) = (0, 0)
    
    var charGrid: [[Letter]] = []
    let words: [LayoutWord]
    
    var enteredAnswers: [String]
    
    
    
    
    // MARK: Lifecycle
    
    init(words: [LayoutWord]) {
        self.words = words
        self.enteredAnswers = Array(repeating: "", count: words.count)
        
        super.init()
        
        size = calculateBounds()
        setupCharGrid()
    }
    
    
    // MARK: Public
    
    func setup(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        
        let nib = UINib(nibName: Constants.cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.cellIdentifier)
        
        collectionView.reloadData()
    }
    
    
    // MARK: Private
    
    private func setupCharGrid() {
        charGrid = Array(repeating: Array(repeating: Letter(value: ""), count: size.0), count: size.1)
        
        for (index, item) in words.enumerated() {
            guard
                item.column >= 0,
                item.row >= 0
            else {
                return // alert damaged file is needed
            }
            
            switch item.direction {
            case .horizontal:
                charGrid[item.row][item.column].value = "\(index + 1) "
                charGrid[item.row][item.column].word = item
                charGrid[item.row][item.column].indexes += [index]
                
                (1...item.answer.count).forEach {
                    charGrid[item.row][item.column + $0].value = " "
                    charGrid[item.row][item.column + $0].word = item
                    charGrid[item.row][item.column + $0].indexes += [index]
                }
                
            case .vertical:
                charGrid[item.row][item.column].value = "\(index + 1) "
                charGrid[item.row][item.column].word = item
                charGrid[item.row][item.column].indexes += [index]
                
                (1...item.answer.count).forEach {
                    charGrid[item.row + $0][item.column].value = " "
                    charGrid[item.row + $0][item.column].word = item
                    charGrid[item.row + $0][item.column].indexes += [index]
                }
            }
        }
    }
    
    private func calculateBounds() -> (Int, Int) {
        let rightXs = words.map { $0.column + ($0.direction == .horizontal ? $0.answer.count : 0) }
        let bottomYs = words.map { $0.row + ($0.direction == .vertical ? $0.answer.count : 0) }
        
        guard
            let x = rightXs.max(),
            let y = bottomYs.max(),
            x >= 0, y >= 0
        else { return (0, 0) }
        
        return (x + 1, y + 1)
    }
}




// MARK: - UICollectionViewDataSource

extension FillDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return max(size.rows, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return size.columns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GridViewCell
        
        if let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier,
                                                                 for: indexPath) as? GridViewCell {
            cell = dequeuedCell
            
            let letter = charGrid[indexPath.section][indexPath.row]
            if letter.value.last == " " && letter.value.count > 1 {
                cell.setup(with: .indexed(letter.value))
            } else if letter.value == "" {
                cell.setup(with: .white)
            } else {
                cell.setup(with: .black(letter.value))
            }
        } else {
            cell = GridViewCell()
        }
        
        return cell
    }
}
