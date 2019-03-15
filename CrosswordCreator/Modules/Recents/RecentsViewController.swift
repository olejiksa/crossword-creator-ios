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
        static let noCrosswords = "You don't have any terms list\nand crosswords yet"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    // MARK: Private
    
    private func setupView() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UINib(nibName: "\(RecentsCell.self)", bundle: Bundle.main), forCellReuseIdentifier: "\(RecentsCell.self)")
    }
    
    private func setupEmptyView(in tableView: UITableView) {
        let origin = CGPoint(x: 0, y: 0)
        let width = tableView.bounds.size.width
        let height = tableView.bounds.size.height
        let size = CGSize(width: width, height: height)
        let rectangle = CGRect(origin: origin, size: size)
        
        let noItemsLabel = UILabel(frame: rectangle)
        noItemsLabel.text = Constants.noCrosswords
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

extension RecentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = interactor.getCrosswords().count
        
        if count == 0 {
            setupEmptyView(in: tableView)
        } else {
            restore(in: tableView)
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (title, date, isTermsList) = interactor.getCrosswordWithDates()[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(RecentsCell.self)", for: indexPath) as? RecentsCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "\(UITableViewCell.self)")
        }
        
        cell.titleLabel?.text = title
        cell.secondSubtitle?.text = isTermsList ? "Terms List" : "Crossword"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        cell.firstSubtitle?.text = dateFormatter.string(from: date)
        return cell
    }
}




// MARK: - UITableViewDelegate

extension RecentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let isTermsList = interactor.isTermsList(at: indexPath.row)
        
        if !isTermsList {
            let words = interactor.getWords(at: indexPath.row)
            let vc = FillBuilder.viewController(words: words)
            let navigationController = UINavigationController(rootViewController: vc)
            present(navigationController)
        } else {
            let vc = ListBuilder.viewController()
            let navigationVC = UINavigationController(rootViewController: vc)
            present(navigationVC)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let index = indexPath.row
        interactor.removeCrossword(at: index)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
