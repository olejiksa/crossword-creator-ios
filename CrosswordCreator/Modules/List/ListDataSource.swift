//
//  ListDataSource.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol ListDataSourceProtocol {
    
    var title: String { get }
    var words: [Word] { get }
    var lastIndex: Int { get }
    
    func setup(with: UITableView)
    func save(with title: String, mode: Bool)
}

final class ListDataSource: NSObject, ListDataSourceProtocol {
    
    private enum Constants {
        
        static let noWords = "words_no_items".localized
    }
    
    var lastIndex: Int {
        return words.index(before: words.endIndex)
    }
    
    private let cellIdentifier = "\(ListViewCell.self)"
    private let interactor: ListInteractorProtocol
    private(set) var words: [Word] = []
    let title: String
    
    weak var vc: ListViewControllerDelegate?
    
    init(interactor: ListInteractorProtocol,
         words: [Word],
         title: String) {
        self.interactor = interactor
        self.words = words
        self.title = title
    }
    
    
    // MARK: Public
    
    func setup(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func save(with title: String, mode: Bool) {
        interactor.save(words, with: title, mode: mode)
    }
}




// MARK: - UITableViewDataSource

extension ListDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if words.isEmpty {
            tableView.setupEmptyView(with: Constants.noWords)
        } else {
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
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
    
        let index = indexPath.section
        words.remove(at: index)
        interactor.removeWord(at: index)
        
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        tableView.endUpdates()
        
        vc?.updateVisibility()
    }
}




// MARK: - WordViewControllerDelegate

extension ListDataSource: WordViewControllerDelegate {
    
    func addWord(_ word: Word) {
        words.append(word)
        interactor.updateWord((word, lastIndex))
        vc?.updateVisibility()
    }
    
    func replaceWord(by newWord: Word, at index: Int) {
        words[index] = newWord
        interactor.updateWord((newWord, index))
        vc?.updateVisibility()
    }
}
