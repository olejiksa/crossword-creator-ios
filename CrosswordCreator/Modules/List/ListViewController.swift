//
//  ListViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 19/10/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let delete = "delete".localized
        static let title = "list_title".localized
        static let noWords = "words_no_items".localized
    }
    
    
    // MARK: Public Properties
    
    var router: ListRouterProtocol?
    

    // MARK: Private Properties
    
    private let xmlService: XmlServiceProtocol
    private let mode: Bool
    private let searchController = UISearchController(searchResultsController: nil)
    
    var lastIndex: Int {
        return words.index(before: words.endIndex)
    }
    
    private let cellIdentifier = "\(ListViewCell.self)"
    private let interactor: ListInteractorProtocol
    private(set) var words: [Word] = []
    private(set) var searchedWords: [Word] = []
    let list_title: String
    
    private var saveButton: UIBarButtonItem?
    var index = 0
    
    override var previewActionItems: [UIPreviewActionItem] {
        let deleteAction = UIPreviewAction(title: Constants.delete, style: .destructive) { (action, viewController) -> Void in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let persistanceManager = appDelegate.persistanceManager
            
            let crosswords: [Crossword] = persistanceManager.fetch(entityName: "Crossword")
            persistanceManager.remove(crosswords[self.index])
            persistanceManager.save()
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTheTable"), object: nil)
        }
        
        return [deleteAction]
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    
    
    // MARK: Lifecycle
    
    init(xmlService: XmlServiceProtocol,
         mode: Bool,
         words: [Word],
         list_title: String,
         interactor: ListInteractorProtocol) {
        self.xmlService = xmlService
        self.mode = mode
        self.words = words
        self.list_title = list_title
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            undoManager?.undo()
        }
    }
    
    // MARK: Private
    
    private func setupView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        setupNavigationBar()
        setupSearchController()
    }
    
    private func setupNavigationBar() {
        title = list_title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(willCancel))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(willOpenWord))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(willShare))
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(willSave))
        self.saveButton = saveButton
        
        shareButton.isEnabled = !words.isEmpty
        saveButton.isEnabled = false
        
        navigationItem.leftBarButtonItem = cancelButton
        
        if !mode {
            navigationItem.rightBarButtonItems = [addButton, shareButton, saveButton]
        } else {
            navigationItem.rightBarButtonItems = [addButton, shareButton]
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    private func filterContent(for searchText: String) {
        searchedWords = words.filter {
            $0.question.localizedCaseInsensitiveContains(searchText)
                || $0.answer.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    @objc private func willOpenWord() {
        router?.wantsToOpenWordEditor(with: .new)
    }
    
    @objc private func willShare() {
        router?.wantsToShare(with: list_title, view: view, words: words)
    }
    
    @objc private func willCancel() {
        router?.wantsToGoBack()
    }
    
    @objc private func willSave() {
        if !mode {
            router?.wantsToSave()
        } else {
            interactor.save(words, with: list_title, mode: mode)
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
}




// MARK: - WordViewControllerDelegate

extension ListViewController: WordViewControllerDelegate {
    
    func addWord(_ word: Word) {
        words.append(word)
        interactor.updateWord((word, lastIndex))
        updateVisibility()
        
        tableView.beginUpdates()
        
        let indexSet = IndexSet(arrayLiteral: lastIndex)
        tableView.insertSections(indexSet, with: .automatic)
        
        tableView.endUpdates()
        
        let indexPath = IndexPath(row: 0, section: lastIndex)
        
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func replaceWord(by newWord: Word, at index: Int) {
        words[index] = newWord
        interactor.updateWord((newWord, index))
        updateVisibility()
        
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
        
        willSave()
    }
}




// MARK: - SaveAlertControllerDelegate

extension ListViewController: SaveAlertControllerDelegate {
    
    func save(with title: String) {
        interactor.save(words, with: title, mode: mode)
        router?.wantsToGoBack()
    }
}


// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let array = searchController.isActive ? searchedWords : words
        
        if array.isEmpty {
            tableView.setupEmptyView(with: Constants.noWords)
        } else {
            tableView.restore()
        }
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListViewCell
        let array = searchController.isActive ? searchedWords : words
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                            for: indexPath) as? ListViewCell {
            cell = dequeuedCell
        } else {
            cell = ListViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let word = array[indexPath.section]
        cell.setup(with: word)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
    
        let index = indexPath.section
        let word = words[indexPath.section]
        
        words.remove(at: index)
        interactor.removeWord(at: index)
        
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        tableView.endUpdates()
        
        undoManager?.registerUndo(withTarget: self, handler: { (selfTarget) in
            selfTarget.addWord(word)
        })
        
        updateVisibility()
    }
}




// MARK: - UISearchResultsUpdating

extension ListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContent(for: searchText)
        tableView.reloadData()
    }
}
