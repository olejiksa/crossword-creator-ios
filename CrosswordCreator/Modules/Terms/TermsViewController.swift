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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
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
        
        registerForPreviewing(with: self, sourceView: tableView)
    }
    
    private func setupNavigationBar() {
        title = Constants.title
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if words.isEmpty {
            nextButton.isEnabled = false
            tableView.setupEmptyView(with: Constants.noWords)
        } else {
            nextButton.isEnabled = true
            tableView.restore()
        }
        
        return words.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListViewCell
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                            for: indexPath) as? ListViewCell {
            cell = dequeuedCell
        } else {
            cell = ListViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let word = words[indexPath.section]
        cell.setup(with: word)
        
        cell.layer.cornerRadius = 15.0
        cell.clipsToBounds = true
        
        return cell
    }
}




// MARK: - UITableViewDelegate

extension TermsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == words.count - 1 ? 10 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}




// MARK: - RecentsModuleOutput

extension TermsViewController: RecentsModuleOutput {
    
    func transferWords(_ words: [Word]) {
        self.words = words
        
        tableView.reloadData()
    }
}




// MARK: - UIViewControllerPreviewingDelegate

extension TermsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        // unused
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            
            if let cell = tableView.cellForRow(at: indexPath) as? ListViewCell,
                let word = cell.word {
                return WordBuilder.viewController(with: .edit(word, indexPath.section))
            } else { return nil }
        }
        
        return nil
    }
}
