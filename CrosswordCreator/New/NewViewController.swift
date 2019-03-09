//
//  NewViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class NewViewController: UIViewController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        static let title = "New"
    }
    
    
    // MARK: Public Properties
    
    var router: NewRouterProtocol?
    
    
    

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    
    // MARK: Private
    
    private func setupView() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction private func selectList() {
        router?.wantsToOpenListEditor()
    }
    
    @IBAction private func createList() {
        router?.wantsToOpenListEditor()
    }
    
    @IBAction private func createGrid() {
        router?.wantsToOpenGridEditor()
    }
}
