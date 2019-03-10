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
    
    private let words: [Word]
    private let mode: Mode
    private let cellIdentifier = "\(UITableViewCell.self)"
    
    init(with words: [Word], mode: Mode) {
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
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: cellIdentifier)
        
        title = mode == .questions ? Constants.questions : Constants.words
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //let nib = UINib(nibName: cellIdentifier, bundle: nil)
        //tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
}




// MARK: - UITableViewDataSource

extension RollViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let word = words[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = mode == .questions ? word.question : word.answer
        return cell
    }
}




// MARK: - UITableViewDelegate

extension RollViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
