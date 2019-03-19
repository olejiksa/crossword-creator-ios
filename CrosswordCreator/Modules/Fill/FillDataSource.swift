//
//  FillDataSource.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol FillDataSourceProtocol {
    
    var charGrid: [[String]] { get }
    var words: [LayoutWord] { get }
    
    func setup(with: UICollectionView)
}

final class FillDataSource: NSObject, FillDataSourceProtocol {
    
    private enum Constants {
        
        static let cellIdentifier = "GridViewCell"
    }
    
    private let size: (columns: Int, rows: Int)
    
    var charGrid: [[String]]
    let words: [LayoutWord]
    
    
    
    
    // MARK: Lifecycle
    
    init(words: [LayoutWord]) {
        self.words = words
        
        size = (16, 16)
        charGrid = Array(repeating: Array(repeating: "", count: 16), count: 16)
        
        super.init()
        
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
        for (index, item) in words.enumerated() {
            switch item.direction {
            case .horizontal:
                charGrid[item.row][item.column - 1] = "\(index + 1) "
                (0..<item.answer.count).forEach { charGrid[item.row][item.column + $0] = " " }
                
            case .vertical:
                charGrid[item.row - 1][item.column] = "\(index + 1) "
                (0..<item.answer.count).forEach { charGrid[item.row + $0][item.column] = " " }
            }
        }
    }
}




// MARK: - UICollectionViewDataSource

extension FillDataSource: UICollectionViewDataSource {
    
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
            
            let character = charGrid[indexPath.section][indexPath.row]
            if character.last == " " {
                cell.setup(with: .indexed(character))
            } else if character == "" {
                cell.setup(with: .white)
            } else {
                cell.setup(with: .black(character))
            }
        } else {
            cell = GridViewCell()
        }
        
        return cell
    }
}
