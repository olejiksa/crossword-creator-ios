//
//  AboutViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class AboutViewController: UIViewController {

    private let presenter: AboutPresenter
    var router: AboutRouterProtocol?
    private var tableView: UITableView?
    
    init(presenter: AboutPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupView()
    }
}

// MARK: - Private

private extension AboutViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "about".localized
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close,
                                                  target: self,
                                                  action: #selector(close))
    }
    
    func setupTableView() {
        let tableViewStyle: UITableView.Style = .grouped
        let tableView = UITableView(frame: .zero, style: tableViewStyle)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let keyboardHeightLayoutConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardHeightLayoutConstraint
        ])
        
        tableView.allowsSelection = false
        tableView.dataSource = presenter.dataSource
        tableView.register(RightDetailCell.self)
        
        self.tableView = tableView
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func close() {
        router?.wantsToGoBack()
    }
}
