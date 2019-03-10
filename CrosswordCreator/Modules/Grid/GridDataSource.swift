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
        
        static let noWords = "You don't have any words yet"
        static let cellIdentifier = "GridViewCell"
    }
    
    private let generator: CrosswordsGeneratorProtocol
    private let interactor: GridInteractorProtocol
    private let size: (columns: Int, rows: Int)
    
    private var charGrid: [[String]]
    var words: [LayoutWord] = []
    
    
    
    
    // MARK: Lifecycle
    
    init(generator: CrosswordsGeneratorProtocol,
         interactor: GridInteractorProtocol) {
        self.generator = generator
        self.interactor = interactor
        
        generator.generate()
        
        size = (generator.columns, generator.rows)
        charGrid = Array(repeating: Array(repeating: String(), count: 16), count: 16)
        
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
    
    func save(with title: String) {
        interactor.saveGrid(words, with: title)
    }
    
    
    // MARK: Private
    
    private func setupCharGrid() {
        words = generator.result
        
        for item in generator.result {
            switch item.direction {
            case .horizontal:
                (0..<item.answer.count).forEach { charGrid[item.row][item.column + $0] = String(item.answer[$0]) }
                
            case .vertical:
                (0..<item.answer.count).forEach { charGrid[item.row + $0][item.column] = String(item.answer[$0]) }
            }
        }
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
            
            let character = charGrid[indexPath.section][indexPath.row]
            if character != String() {
                cell.setup(with: .black(character))
            } else {
                cell.setup(with: .white)
            }
        } else {
            cell = GridViewCell()
            cell.setup(with: .white)
        }
        
        return cell
    }
}
