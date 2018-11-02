//
//  HomeViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 01/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "Home"
    }
    
    
    // MARK: Public Properties
    
    var router: HomeRouterProtocol?
    
    
    
    
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
    
    @IBAction private func didListEditorButtonTap() {
        router?.wantsToOpenListEditor()
    }
}
