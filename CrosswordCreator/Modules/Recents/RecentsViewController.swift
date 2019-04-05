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
    
    
    // MARK: Public Properties
    
    var router: RecentsRouterProtocol?
    
    
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
        setupNavBar()
    }
    
    private func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(willAdd))
        navigationItem.rightBarButtonItem = addButton
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
    
    @objc private func willAdd() {
        let alert = UIAlertController(title: "New",
                                      message: "Create new terms list or crossword",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Terms List", style: .default) { [weak self] _ in
            let listViewController = ListBuilder.viewController()
            let navigationController = UINavigationController(rootViewController: listViewController)
            
            self?.present(navigationController)
        })
        
        alert.addAction(UIAlertAction(title: "Crossword", style: .default) { [weak self] _ in
            let gridViewController = GridBuilder.viewController(words: [])
            let navigationController = UINavigationController(rootViewController: gridViewController)
            
            self?.present(navigationController)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert)
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
        
        let index = indexPath.row
        let title = interactor.getCrosswords()[index]
        
        if interactor.isTermsList(at: index) {
            let words = interactor.getWords(at: index)
            router?.wantsToOpenListEditor(with: title, words: words)
        } else {
            let layoutWords = interactor.getLayoutWords(at: index)
            router?.wantsToFill(with: title, words: layoutWords)
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
