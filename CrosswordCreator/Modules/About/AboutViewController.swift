//
//  AboutViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController {

    var router: AboutRouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "About"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(willCancel))
        
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func willCancel() {
        router?.wantsToGoBack()
    }
}
