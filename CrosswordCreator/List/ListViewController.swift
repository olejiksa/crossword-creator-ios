//
//  ListViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 19/10/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    typealias WordsListDataSource = ListDataSourceProtocol & WordAlertControllerDelegate
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "List Editor"
    }
    
    
    // MARK: Public Properties
    
    var router: ListRouterProtocol?
    

    // MARK: Private Properties
    
    private let dataSource: WordsListDataSource
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    
    
    // MARK: Lifecycle
    
    init(dataSource: WordsListDataSource) {
        self.dataSource = dataSource
        
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
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                target: self,
                                                action: nil)
        
        navigationItem.setRightBarButton(saveBarButtonItem, animated: true)
        
        dataSource.setup(with: tableView)
    }
    
    @IBAction private func openWordAlertController(_ sender: UIBarButtonItem) {
        router?.wantsToOpenWordEditor(with: .new)
    }
}




// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? ListViewCell,
            let existingWord = cell.word
        else { return }
        
        router?.wantsToOpenWordEditor(with: .edit(existingWord, indexPath.row))
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




// MARK: - WordAlertControllerDelegate

extension ListViewController: WordAlertControllerDelegate {
    
    func addWord(_ word: Word) {
        dataSource.addWord(word)
        
        tableView.beginUpdates()
        
        let indexPath = IndexPath(row: dataSource.lastIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        tableView.endUpdates()
    }
    
    func replaceWord(by newWord: Word, at index: Int) {
        dataSource.replaceWord(by: newWord, at: index)
        
        tableView.beginUpdates()
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        tableView.endUpdates()
    }
}
