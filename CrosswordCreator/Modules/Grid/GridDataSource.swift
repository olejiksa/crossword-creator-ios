//
//  GridDataSource.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 11/01/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol GridDataSourceProtocol {
    
    var words: [LayoutWord] { get }
    
    func setup(with: UICollectionView)
    func save(with title: String)
}

final class GridDataSource: NSObject, GridDataSourceProtocol {
    
    private enum Constants {
        
        static let cellIdentifier = "GridViewCell"
    }
    
    private let interactor: GridInteractorProtocol
    private var size: (columns: Int, rows: Int) = (0, 0)
    
    private var charGrid: [[String]] = []
    var words: [LayoutWord] = []
    
    
    
    
    // MARK: Lifecycle
    
    init(interactor: GridInteractorProtocol,
         words: [LayoutWord]) {
        self.interactor = interactor
        self.words = words
        
        super.init()
        
        size = calculateBounds()
        
        charGrid = Array(repeating: Array(repeating: String(), count: 32), count: 32)
        setupCharGrid()
    }
    
    
    // MARK: Public
    
    func setup(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        
        let nib = UINib(nibName: Constants.cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.cellIdentifier)
        
        collectionView.reloadData()
    }
    
    func save(with title: String) {
        interactor.save(words, with: title)
    }
    
    
    // MARK: Private
    
    private func setupCharGrid() {
        for (index, item) in words.enumerated() {
            guard
                item.column > 0,
                item.row > 0
            else {
                return // alert damaged file is needed
            }
            
            switch item.direction {
            case .horizontal:
                charGrid[item.row][item.column - 1] = String(index + 1) + " "
                (0..<item.answer.count).forEach { charGrid[item.row][item.column + $0] = String(item.answer[$0]) }
                
            case .vertical:
                charGrid[item.row - 1][item.column] = String(index + 1) + " "
                (0..<item.answer.count).forEach { charGrid[item.row + $0][item.column] = String(item.answer[$0]) }
            }
        }
        
        words = words.map {
            switch $0.direction {
            case .horizontal:
                return LayoutWord(question: $0.question,
                                  answer: $0.answer,
                                  column: $0.column - 1,
                                  row: $0.row,
                                  direction: $0.direction)
                
            case .vertical:
                return LayoutWord(question: $0.question,
                                  answer: $0.answer,
                                  column: $0.column,
                                  row: $0.row - 1,
                                  direction: $0.direction)
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

extension GridDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return size.rows
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
            if letter.last == " " && letter.count > 1 {
                cell.setup(with: .indexed(letter))
            } else if letter == "" {
                cell.setup(with: .white)
            } else {
                cell.setup(with: .black(letter))
            }
        } else {
            cell = GridViewCell()
        }
        
        return cell
    }
}
