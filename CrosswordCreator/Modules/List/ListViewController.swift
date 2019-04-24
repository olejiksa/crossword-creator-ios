//
//  ListViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 19/10/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    typealias WordsListDataSource = ListDataSourceProtocol & WordViewControllerDelegate
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "List"
    }
    
    
    // MARK: Public Properties
    
    var router: ListRouterProtocol?
    

    // MARK: Private Properties
    
    private let dataSource: WordsListDataSource
    private let xmlService: XmlServiceProtocol
    private let mode: Bool
    
    private var saveButton: UIBarButtonItem?
    var index = 0
    
    override var previewActionItems: [UIPreviewActionItem] {
        let deleteAction = UIPreviewAction(title: "Delete", style: .destructive) { (action, viewController) -> Void in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let persistanceManager = appDelegate.persistanceManager
            
            let crosswords: [Crossword] = persistanceManager.fetch(entityName: "Crossword")
            persistanceManager.remove(crosswords[self.index])
            persistanceManager.save()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTheTable"), object: nil)
        }
        
        return [deleteAction]
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    
    
    // MARK: Lifecycle
    
    init(dataSource: WordsListDataSource,
         xmlService: XmlServiceProtocol,
         mode: Bool) {
        self.dataSource = dataSource
        self.xmlService = xmlService
        self.mode = mode
        
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
        dataSource.setup(with: tableView)
        setupNavigationBar()
        setupToolbar()
        
        //registerForPreviewing(with: self, sourceView: tableView)
    }
    
    private func setupNavigationBar() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(willCancel))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(willShare))
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(willSave))
        self.saveButton = saveButton
        
        shareButton.isEnabled = !dataSource.words.isEmpty
        saveButton.isEnabled = false
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItems = [shareButton, saveButton]
    }
    
    private func setupToolbar() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openWordAlertController))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbarItems = [spacer, add]
    }
    
    @objc private func openWordAlertController() {
        router?.wantsToOpenWordEditor(with: .new)
    }
    
    @objc private func willShare() {
        router?.wantsToShare(with: dataSource.title, view: view, words: dataSource.words)
    }
    
    @objc private func willCancel() {
        router?.wantsToGoBack()
    }
    
    @objc private func willSave() {
        if !mode {
            router?.wantsToSave()
        } else {
            dataSource.save(with: dataSource.title, mode: mode)
            self.saveButton?.isEnabled = false
        }
    }
}

protocol ListViewControllerDelegate: class {
    
    func updateVisibility()
}




// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? ListViewCell,
            let existingWord = cell.word
        else { return }
        
        router?.wantsToOpenWordEditor(with: .edit(existingWord, indexPath.section))
        
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
}




// MARK: - WordViewControllerDelegate

extension ListViewController: WordViewControllerDelegate {
    
    func addWord(_ word: Word) {
        dataSource.addWord(word)
        
        tableView.beginUpdates()
        
        let indexSet = IndexSet(arrayLiteral: dataSource.lastIndex)
        tableView.insertSections(indexSet, with: .automatic)
        
        tableView.endUpdates()
        
        let indexPath = IndexPath(row: 0, section: dataSource.lastIndex)
        
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func replaceWord(by newWord: Word, at index: Int) {
        dataSource.replaceWord(by: newWord, at: index)
        
        tableView.beginUpdates()
        
        let indexSet = IndexSet(arrayLiteral: index)
        tableView.reloadSections(indexSet, with: .automatic)
        
        tableView.endUpdates()
    }
}




// MARK: - ListViewControllerDelegate

extension ListViewController: ListViewControllerDelegate {
    
    func updateVisibility() {
        navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = true }
    }
}




// MARK: - SaveAlertControllerDelegate

extension ListViewController: SaveAlertControllerDelegate {
    
    func save(with title: String) {
        dataSource.save(with: title, mode: mode)
        router?.wantsToGoBack()
    }
}



// MARK: - UIViewControllerPreviewingDelegate

//extension ListViewController: UIViewControllerPreviewingDelegate {
//    
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
//                           commit viewControllerToCommit: UIViewController) {
//        navigationController?.pushViewController(viewControllerToCommit, animated: true)
//    }
//    
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
//                           viewControllerForLocation location: CGPoint) -> UIViewController? {
//        if let indexPath = tableView.indexPathForRow(at: location) {
//            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
//            
//            if let cell = tableView.cellForRow(at: indexPath) as? ListViewCell,
//               let word = cell.word {
//                return WordBuilder.viewController(with: .edit(word, indexPath.section))
//            } else { return nil }
//        }
//        
//        return nil
//    }
//}

extension UINavigationController {
    
    override open var previewActionItems: [UIPreviewActionItem] {
        return topViewController?.previewActionItems ?? []
    }
}
