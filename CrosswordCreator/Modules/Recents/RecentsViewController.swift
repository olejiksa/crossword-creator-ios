//
//  RecentsViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit
import CoreGraphics

final class RecentsViewController: UIViewController {
    
    enum Mode {
        case standard, picker
    }
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "Recents"
        static let alternateTitle = "Dictionaries"
        static let noTermsLists = "You don't have any dictionaries yet"
        static let noCrosswords = "You don't have any dictionaries\nand crosswords yet"
    }
    
    
    // MARK: Public Properties
    
    var router: RecentsRouterProtocol?
    var moduleOutput: RecentsModuleOutput?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: Private Properties
    
    private let cellSpacingHeight: CGFloat = 5
    
    private let recentsCell = RecentsCell.self
    private let subtitleCell = SubtitleCell.self
    
    private let interactor: RecentsInteractorProtocol
    
    private let mode: Mode
    private var checkedSections: [Int] = []
    
    
    
    
    // MARK: Lifecycle
    
    init(interactor: RecentsInteractorProtocol, mode: Mode = .standard) {
        self.interactor = interactor
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "reloadTheTable"), object: nil)
        setupView()
        interactor.setupSearchableContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    // MARK: Private
    
    private func setupView() {
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = mode == .standard ? Constants.title : Constants.alternateTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        switch mode {
        case .standard:
            let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(willAdd))
            navigationItem.rightBarButtonItem = addButton
            
        case .picker:
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                               target: self,
                                               action: #selector(willCancel))
            navigationItem.leftBarButtonItem = cancelButton
            
            let doneButton = UIBarButtonItem(title: "Done",
                                             style: .plain,
                                             target: self,
                                             action: #selector(willDone))
            navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    private func setupTableView() {
        switch mode {
        case .standard:
            let nib = UINib(nibName: "\(recentsCell)", bundle: Bundle.main)
            tableView.register(nib, forCellReuseIdentifier: "\(recentsCell)")
            
        case .picker:
            tableView.register(subtitleCell, forCellReuseIdentifier: "\(subtitleCell)")
        }
        
        tableView.allowsMultipleSelection = mode == .picker
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
    }
    
    @objc private func willAdd() {
        router?.wantsToCreate(with: self)
    }
    
    @objc private func willCancel() {
        router?.wantsToGoBack()
    }
    
    @objc private func willDone() {
        let words = checkedSections
            .map(interactor.getWords)
            .flatMap { $0 }
        
        moduleOutput?.transferWords(words)
        router?.wantsToGoBack()
    }
    
    @objc private func refresh() {
        tableView.reloadData()
    }
}




// MARK: - UITableViewDataSource

extension RecentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = interactor.getCrosswords().count
        
        if count == 0 {
            tableView.setupEmptyView(with: mode == .standard ? Constants.noCrosswords : Constants.noTermsLists)
        } else {
            tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (title, date, isTermsList) = interactor.getCrosswordWithDates()[indexPath.section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let dateString = dateFormatter.string(from: date)
        
        switch mode {
        case .standard:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(recentsCell)", for: indexPath) as? RecentsCell else {
                return UITableViewCell(style: .default, reuseIdentifier: "\(UITableViewCell.self)")
            }
            
            cell.titleLabel?.text = title
            cell.secondSubtitle?.text = isTermsList ? "Dictionary" : "Crossword"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            
            cell.firstSubtitle?.text = dateString
            
            cell.layer.cornerRadius = 15.0
            cell.clipsToBounds = true
            
            return cell
            
        case .picker:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(subtitleCell)", for: indexPath)
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = dateString
            
            cell.layer.cornerRadius = 15.0
            cell.clipsToBounds = true
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}




// MARK: - UITableViewDelegate

extension RecentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if mode == .standard {
            let index = indexPath.section
            let title = interactor.getCrosswords()[index]
            
            if interactor.isTermsList(at: index) {
                let words = interactor.getWords(at: index)
                router?.wantsToOpenListEditor(with: title, words: words)
            } else {
                let layoutWords = interactor.getLayoutWords(at: index)
                router?.wantsToFill(with: title, words: layoutWords)
            }
        } else if let cell = tableView.cellForRow(at: indexPath) {
            switch cell.accessoryType {
            case .none:
                cell.accessoryType = .checkmark
                checkedSections.append(indexPath.section)
                
            case .checkmark:
                cell.accessoryType = .none
                if let index = checkedSections.firstIndex(where: { $0 == indexPath.section }) {
                    checkedSections.remove(at: index)
                }
                
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if mode == .picker {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return mode == .standard
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let index = indexPath.section
        interactor.removeCrossword(at: index)
        
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        tableView.endUpdates()
    }
}
