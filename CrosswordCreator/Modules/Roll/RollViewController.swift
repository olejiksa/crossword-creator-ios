//
//  RollViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 10/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RollViewController: UIViewController {
    
    // MARK: Public Data Structures
    
    enum Mode {
        
        case questions
        case answers
    }
    
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let across = "questions_across".localized
        static let down = "questions_down".localized
        static let questions = "questions".localized
        static let words = "words_title".localized
    }
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: Private Properties
    
    private let words: [LayoutWord]
    private let mode: Mode
    private let cellIdentifier = "\(RollCell.self)"
    private var searchController: UISearchController!
    
    
    // MARK: Public Properties
    
    weak var delegate: RollDelegate?
    
    var across: [LayoutWord] {
        return words.filter { $0.direction == .horizontal }
    }
    
    var down: [LayoutWord] {
        return words.filter { $0.direction == .vertical }
    }
    
    var searchedAcross: [LayoutWord] = []
    var searchedDown: [LayoutWord] = []
    
    
    
    
    // MARK: Lifecycle
    
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
        
        setupTableView()
        setupSearchController()
        setupNavigation()
        setupKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    
    // MARK: Private
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main),
                           forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupNavigation() {
        navigationItem.title = mode == .questions ? Constants.questions : Constants.words
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustKeyboard),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func filterContent(for searchText: String) {
        searchedAcross = across.filter { $0.question.localizedCaseInsensitiveContains(searchText) }
        searchedDown = down.filter { $0.question.localizedCaseInsensitiveContains(searchText) }
    }
    
    @objc
    private func adjustKeyboard(notification: Notification) {
        guard
            let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            let bottom = keyboardViewEndFrame.height - view.safeAreaInsets.bottom
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
        }

        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}




// MARK: - UITableViewDataSource

extension RollViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        guard self.tableView(tableView, numberOfRowsInSection: section) > 0 else {
            return nil
        }
        
        return section == 0 ? Constants.across : Constants.down
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch (section, searchController.isActive) {
            case (0, true):
                return searchedAcross.count
                
            case (0, false):
                return across.count

            case (_, true):
                return searchedDown.count
                
            case (_, false):
                return down.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let word: LayoutWord
        switch (indexPath.section, searchController.isActive) {
        case (0, true):
            word = searchedAcross[indexPath.row]
            
        case (0, false):
            word = across[indexPath.row]

        case (_, true):
            word = searchedDown[indexPath.row]
            
        case (_, false):
            word = down[indexPath.row]
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RollCell else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        cell.nameLabel?.text = mode == .questions ? word.question : word.answer
        cell.indexLabel?.text = String((words.enumerated().first(where: { $0.element == word })?.offset ?? 0) + 1)
        return cell
    }
}




// MARK: - UITableViewDelegate

extension RollViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word: LayoutWord
        switch (indexPath.section, searchController.isActive) {
        case (0, true):
            word = searchedAcross[indexPath.row]
            
        case (0, false):
            word = across[indexPath.row]

        case (_, true):
            word = searchedDown[indexPath.row]
            
        case (_, false):
            word = down[indexPath.row]
        }
        
        navigationController?.popViewController(animated: true)
        
        let index = words.enumerated().first(where: { $0.element == word })?.offset ?? 0
        delegate?.openFillDialog(with: word, by: index)
    }
}




// MARK: - UISearchResultsUpdating

extension RollViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContent(for: searchText)
        tableView.reloadData()
    }
}
