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
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(willCancel))
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(willSave))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(willShare))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItems = [shareButton, saveButton]
    }
    
    @objc private func willCancel() {
        router?.wantsToGoBack()
    }
    
    @objc private func willSave() {
        router?.wantsToSave()
    }
    
    @objc private func willShare() {
        let xml = xmlService.writeGrid(with: dataSource.words)
        let filename = "untitled.\(FileExtension.grid.rawValue)"
        
        do {
            let fileURL = URL(fileURLWithPath: getDocumentsDirectory()).appendingPathComponent(filename)
            try xml.write(to: fileURL, atomically: true, encoding: .utf8)
            
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = view
            present(activityVC, animated: true)
            
        } catch {
            print("cannot write file")
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    @objc private func willPrintGrid() {
        // WARN: DOESN'T WORK at ALL!!!!
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = .grayscale
        printInfo.jobName = "My Print Job"
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        collectionView.screenshot(completion: { [weak self] image in
            guard let strongSelf = self else { return }
            
            printController.printingItem = image
            printController.present(from: strongSelf.view.frame,
                                    in: strongSelf.view,
                                    animated: true)
        })
    }
    
    private func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}




// MARK: - SaveAlertControllerDelegate

extension GridViewController: SaveAlertControllerDelegate {
    
    func save(with title: String) {
        dataSource.save(with: title)
    }
}
