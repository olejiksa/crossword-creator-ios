//
//  ListDataSource.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 02/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol ListDataSourceProtocol {
    
    var lastIndex: Int { get }
    func setup(with: UITableView)
}

final class ListDataSource: NSObject, ListDataSourceProtocol {
    
    private enum Constants {
        
        static let noWords = "You don't have any words yet"
    }
    
    var lastIndex: Int {
        return words.index(before: words.endIndex)
    }
    
    private let cellIdentifier = "\(ListViewCell.self)"
    private var words: [Word] = []
    
    func setup(with tableView: UITableView) {
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
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
    
        words.remove(at: indexPath.row)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}




// MARK: - WordAlertControllerDelegate

extension ListDataSource: WordAlertControllerDelegate {
    
    func addWord(_ word: Word) {
        words.append(word)
    }
    
    func replaceWord(by newWord: Word, at index: Int) {
        words[index] = newWord
    }
}
