//
//  GridViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class GridViewController: UIViewController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "Grid"
    }
    
    
    // MARK: Private Properties
    
    private let dataSource: GridDataSource
    private let xmlService: XmlServiceProtocol
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: Public Properties
    
    var router: GridRouterProtocol?
    
    
    
    
    // MARK: Lifecycle
    
    init(dataSource: GridDataSource) {
        self.dataSource = dataSource
        self.xmlService = XmlService()
        
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
    }
    
    private func setupNavigationBar() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(willSave))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(willShare))
        
        navigationItem.rightBarButtonItems = [shareButton, saveButton]
    }
    
    @objc private func willSave() {
        router?.wantsToSave()
    }
    
    @objc private func willShare() {
        router?.wantsToShare(with: "Untitled", view: view, layoutWords: dataSource.words)
    }
}




// MARK: - SaveAlertControllerDelegate

extension GridViewController: SaveAlertControllerDelegate {
    
    func save(with title: String) {
        dataSource.save(with: title)
        router?.wantsToGoBack()
    }
}
