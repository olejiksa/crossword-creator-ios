//
//  TermsViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TermsViewController: UIViewController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        static let title = "Words"
        static let noWords = "You don't have any words yet"
    }
    
    
    // MARK: Private Properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var nextButton: UIBarButtonItem!
    
    private(set) var words: [Word] = []
    private let cellIdentifier = "\(ListViewCell.self)"
    
    // MARK: Public Properties
    
    var router: TermsRouterProtocol?
    
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    // MARK: Private
    
    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(willCancel))
        
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func willCancel() {
        router?.wantsToGoBack()
    }
    
    @IBAction func willOpen(_ sender: UIBarButtonItem) {
        router?.wantsToOpen(with: self)
    }
    
    @IBAction func willNext(_ sender: UIBarButtonItem) {
        router?.wantsToGenerate(with: words)
    }
}




// MARK: - UITableViewDataSource

extension TermsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = words.count
        
        if count == 0 {
            nextButton.isEnabled = false
            tableView.setupEmptyView(with: Constants.noWords)
        } else {
            nextButton.isEnabled = true
            tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListViewCell
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                            for: indexPath) as? ListViewCell {
            cell = dequeuedCell
        } else {
            cell = ListViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let word = words[indexPath.row]
        cell.setup(with: word)
        
        return cell
    }
}




// MARK: - UITableViewDelegate

extension TermsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




// MARK: - RecentsModuleOutput

extension TermsViewController: RecentsModuleOutput {
    
    func transferWords(_ words: [Word]) {
        self.words = words
        
        tableView.reloadData()
    }
}
