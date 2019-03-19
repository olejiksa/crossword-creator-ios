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
        
        static let noWords = "You don't have any words yet"
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
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func save(with title: String, mode: Bool) {
        interactor.save(words, with: title, mode: mode)
    }
    
    
    // MARK: Private
    
    private func setupEmptyView(in tableView: UITableView) {
        let origin = CGPoint(x: 0, y: 0)
        let width = tableView.bounds.size.width
        let height = tableView.bounds.size.height
        let size = CGSize(width: width, height: height)
        let rectangle = CGRect(origin: origin, size: size)
        
        let noItemsLabel = UILabel(frame: rectangle)
        noItemsLabel.text = Constants.noWords
        noItemsLabel.textColor = .gray
        noItemsLabel.numberOfLines = 0
        noItemsLabel.textAlignment = .center
        noItemsLabel.sizeToFit()
        
        tableView.backgroundView = noItemsLabel
        tableView.separatorStyle = .none
    }
    
    private func restore(in tableView: UITableView) {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
}




// MARK: - UITableViewDataSource

extension ListDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if words.isEmpty {
            setupEmptyView(in: tableView)
        } else {
            restore(in: tableView)
        }
        
        return words.count
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
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
    
        let index = indexPath.row
        words.remove(at: index)
        interactor.removeWord(at: index)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        vc?.updateVisibility(with: words.isEmpty)
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return title
    }
}




// MARK: - WordAlertControllerDelegate

extension ListDataSource: WordAlertControllerDelegate {
    
    func addWord(_ word: Word) {
        words.append(word)
        interactor.updateWord((word, lastIndex))
        
        vc?.updateVisibility(with: false)
    }
    
    func replaceWord(by newWord: Word, at index: Int) {
        words[index] = newWord
        interactor.updateWord((newWord, index))
    }
}
