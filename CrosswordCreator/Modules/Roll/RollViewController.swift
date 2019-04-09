//
//  RollViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 10/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RollViewController: UIViewController {
    
    enum Mode {
        
        case questions
        case answers
    }
    
    private enum Constants {
        
        static let questions = "Questions"
        static let words = "Words"
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let words: [LayoutWord]
    private let mode: Mode
    private let cellIdentifier = "\(RollCell.self)"
    
    var across: [LayoutWord] {
        return words.filter { $0.direction == .horizontal }
    }
    
    var down: [LayoutWord] {
        return words.filter { $0.direction == .vertical }
    }
    
    init(with words: [LayoutWord], mode: Mode) {
        self.words = words
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "\(RollCell.self)", bundle: Bundle.main),
                           forCellReuseIdentifier: cellIdentifier)
        
        title = mode == .questions ? Constants.questions : Constants.words
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}




// MARK: - UITableViewDataSource

extension RollViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Across" : "Down"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? across.count : down.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let word = indexPath.section == 0 ? across[indexPath.row] : down[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RollCell {
            cell.nameLabel?.text = mode == .questions ? word.question : word.answer
            cell.indexLabel?.text = String((words.enumerated().first(where: { $0.element == word })?.offset ?? 0) + 1)
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
}




// MARK: - UITableViewDelegate

extension RollViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
