//
//  RecentsViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RecentsViewController: UIViewController {
    
    enum Mode {
        case standard, picker
    }
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "Recents"
        static let alternateTitle = "Terms Lists"
        static let noTermsLists = "You don't have any terms lists yet"
        static let noCrosswords = "You don't have any terms lists\nand crosswords yet"
    }
    
    
    // MARK: Public Properties
    
    var router: RecentsRouterProtocol?
    var moduleOutput: RecentsModuleOutput?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: Private Properties
    
    private let interactor: RecentsInteractorProtocol
    private let mode: Mode
    private var checkedRows: [Int] = []
    
    
    
    
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
        title = mode == .standard ? Constants.title : Constants.alternateTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UINib(nibName: "\(RecentsCell.self)", bundle: Bundle.main), forCellReuseIdentifier: "\(RecentsCell.self)")
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "\(SubtitleTableViewCell.self)")
        tableView.allowsMultipleSelection = mode == .picker
        setupNavBar()
    }
    
    private func setupNavBar() {
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
            doneButton.isEnabled = false
            navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    @objc private func willAdd() {
        router?.wantsToCreate(with: self)
    }
    
    @objc private func willCancel() {
        router?.wantsToGoBack()
    }
    
    @objc private func willDone() {
        let words = checkedRows
            .map(interactor.getWords)
            .flatMap { $0 }
        
        moduleOutput?.transferWords(words)
        router?.wantsToGoBack()
    }
    
    private func updateDoneButtonVisibility() {
        navigationItem.rightBarButtonItem?.isEnabled = !checkedRows.isEmpty
    }
    
    @objc private func refresh() {
        tableView.reloadData()
    }
}




// MARK: - UITableViewDataSource

extension RecentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = interactor.getCrosswords().count
        
        if count == 0 {
            tableView.setupEmptyView(with: mode == .standard ? Constants.noCrosswords : Constants.noTermsLists)
        } else {
            tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (title, date, isTermsList) = interactor.getCrosswordWithDates()[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let dateString = dateFormatter.string(from: date)
        
        switch mode {
        case .standard:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(RecentsCell.self)", for: indexPath) as? RecentsCell else {
                return UITableViewCell(style: .default, reuseIdentifier: "\(UITableViewCell.self)")
            }
            
            cell.titleLabel?.text = title
            cell.secondSubtitle?.text = isTermsList ? "Terms List" : "Crossword"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            
            cell.firstSubtitle?.text = dateString
            return cell
            
        case .picker:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(SubtitleTableViewCell.self)", for: indexPath)
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = dateString
            return cell
        }
    }
}




// MARK: - UITableViewDelegate

extension RecentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if mode == .standard {
            let index = indexPath.row
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
                checkedRows.append(indexPath.row)
                
            case .checkmark:
                cell.accessoryType = .none
                if let index = checkedRows.firstIndex(where: { $0 == indexPath.row }) {
                    checkedRows.remove(at: index)
                }
                
            default:
                break
            }
            
            updateDoneButtonVisibility()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if mode == .picker {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
            
            updateDoneButtonVisibility()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return mode == .standard
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
