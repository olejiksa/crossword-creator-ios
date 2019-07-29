//
//  HomeViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 17/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit
import CoreGraphics

final class HomeViewController: UIViewController {
    
    enum Mode {
        case standard, picker
    }
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "home_title".localized
        static let alternateTitle = "dictionaries".localized
        static let noTermsLists = "home_short_no_items".localized
        static let noCrosswords = "home_long_no_items".localized
    }
    
    
    // MARK: Public Properties
    
    var router: HomeRouterProtocol?
    var moduleOutput: HomeModuleOutput?
    var spotlightIndex: Int?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: Private Properties
    
    private let cellSpacingHeight: CGFloat = 5
    
    private let homeCell = HomeCell.self
    private let subtitleCell = SubtitleCell.self
    
    let interactor: HomeInteractorProtocol
    
    private let mode: Mode
    private var checkedSections: [Int] = []
    
    
    
    
    // MARK: Lifecycle
    
    init(interactor: HomeInteractorProtocol, mode: Mode = .standard) {
        self.interactor = interactor
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForPreviewing(with: self, sourceView: tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name(rawValue: "reloadTheTable"), object: nil)
        setupView()
        interactor.setupSearchableContent()
        
        if let spotlightIndex = spotlightIndex {
            tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: spotlightIndex))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
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
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(willDone))
            navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    private func setupTableView() {
        switch mode {
        case .standard:
            let nib = UINib(nibName: "\(homeCell)", bundle: Bundle.main)
            tableView.register(nib, forCellReuseIdentifier: "\(homeCell)")
            
        case .picker:
            tableView.register(subtitleCell, forCellReuseIdentifier: "\(subtitleCell)")
        }
        
        tableView.allowsMultipleSelection = mode == .picker
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
    }
    
    @objc private func willAdd() {
        router?.wantsToCreate(with: self, superview: view)
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

extension HomeViewController: UITableViewDataSource {
    
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(homeCell)", for: indexPath) as? HomeCell else {
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
            
            cell.setNeedsDisplay()
            
            return cell
            
        case .picker:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(subtitleCell)", for: indexPath)
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = dateString
            
            cell.layer.cornerRadius = 15.0
            cell.clipsToBounds = true
            
            cell.setNeedsDisplay()
            
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

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if mode == .standard {
            let index = indexPath.section
            let title = interactor.getCrosswords()[index]
            
            if interactor.isTermsList(at: index) {
                let words = interactor.getWords(at: index)
                router?.wantsToOpenListEditor(with: title, words: words, index: index)
            } else {
                let layoutWords = interactor.getLayoutWords(at: index)
                router?.wantsToFill(with: title, words: layoutWords, index: index)
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




// MARK: - UIViewControllerPreviewingDelegate

extension HomeViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit)
        
        (viewControllerToCommit as? UINavigationController)?.setToolbarHidden(false, animated: true)
        (viewControllerToCommit as? UINavigationController)?.setNavigationBarHidden(false, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            
            let cell = tableView.cellForRow(at: indexPath)
            
            switch cell {
            case is SubtitleCell:
                break
                
            case is HomeCell:
                if (cell as? HomeCell)?.secondSubtitle?.text == "Dictionary",
                    let title = (cell as? HomeCell)?.titleLabel?.text {
                    let words = interactor.getWords(at: indexPath.section)
                    let index = indexPath.section
                    
                    let vc = ListBuilder.viewController(with: title, words: words)
                    vc.index = index
                    let nvc = vc.navigationController
                    
                    nvc?.setToolbarHidden(true, animated: true)
                    nvc?.setNavigationBarHidden(true, animated: true)
                    
                    return nvc
                } else if let title = (cell as? HomeCell)?.titleLabel?.text {
                    let words = interactor.getLayoutWords(at: indexPath.section)
                    let index = indexPath.section
                    
                    let vc = FillBuilder.viewController(with: title, words: words)
                    vc.index = index
                    let nvc = vc.navigationController
                    
                    nvc?.setToolbarHidden(true, animated: true)
                    nvc?.setNavigationBarHidden(true, animated: true)
                    
                    return nvc
                }
                
            default:
                break
            }
        }
        
        return nil
    }
}
