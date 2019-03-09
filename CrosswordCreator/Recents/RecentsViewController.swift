//
//  RecentsViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RecentsViewController: UIViewController {
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "Recents"
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Private Properties
    
    private let interactor: RecentsInteractorProtocol
    private var crosswords: [String] = []
    
    
    
    
    // MARK: Lifecycle
    
    init(interactor: RecentsInteractorProtocol) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        interactor.setupSearchableContent()
    }
    
    
    // MARK: Private
    
    private func setupView() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(SubtitleTableViewCell.self,
                           forCellReuseIdentifier: "\(SubtitleTableViewCell.self)")
    }
}




// MARK: - UITableViewDataSource

extension RecentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getCrosswords().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (title, date) = interactor.getCrosswordWithDates()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SubtitleTableViewCell.self)",
                                                 for: indexPath)
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = date.description
        return cell
    }
}




// MARK: - UITableViewDelegate

extension RecentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
