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
    private var scale: Float = 50
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: Public Properties
    
    var router: GridRouterProtocol?
    
    
    
    
    // MARK: Lifecycle
    
    init(dataSource: GridDataSource,
         xmlService: XmlServiceProtocol) {
        self.dataSource = dataSource
        self.xmlService = xmlService
        
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
    
    @IBAction func didZoomTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title:"Zoom",
                                                message: nil,
                                                preferredStyle: .alert)
        let slider = UISlider(frame: CGRect(x: 35, y: 50, width: 200, height: 20))
        slider.minimumValue = 25
        slider.maximumValue = 50
        slider.value = scale
        alertController.view.addSubview(slider)
        
        let height = NSLayoutConstraint(item: alertController.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 140)
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
        //  collectionView.collectionViewLayout = NodeLayout(itemWidth: 25, itemHeight: 25, space: 1)
    }
}




// MARK: - SaveAlertControllerDelegate

extension GridViewController: SaveAlertControllerDelegate {
    
    func save(with title: String) {
        dataSource.save(with: title)
        router?.wantsToGoBack()
    }
}
