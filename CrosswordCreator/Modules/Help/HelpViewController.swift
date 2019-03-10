//
//  HelpViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/02/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class HelpViewController: UIViewController {

    // MARK: Private Data Structures
    
    private enum Constants {
        static let title = "Help"
    }
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Private Properties
    
    private var helpSections: [String] = ["About",
                                          "Navigation",
                                          "Appearance",
                                          "List Editor",
                                          "Grid Editor",
                                          "Fill"]
    
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    
    // MARK: Private
    
    private func setupView() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "\(UITableViewCell.self)")
    }
}




// MARK: - UITableViewDataSource

extension HelpViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = helpSections[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)",
                                                 for: indexPath)
        cell.textLabel?.text = title
        return cell
    }
}




// MARK: - UITableViewDelegate

extension HelpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
