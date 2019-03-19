//
//  ListViewController.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 19/10/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    typealias WordsListDataSource = ListDataSourceProtocol & WordAlertControllerDelegate
    
    // MARK: Private Data Structures
    
    private enum Constants {
        
        static let title = "List"
    }
    
    
    // MARK: Public Properties
    
    var router: ListRouterProtocol?
    

    // MARK: Private Properties
    
    private let dataSource: WordsListDataSource
    private let xmlService: XmlServiceProtocol
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    
    
    // MARK: Lifecycle
    
    init(dataSource: WordsListDataSource,
         xmlService: XmlServiceProtocol) {
        self.dataSource = dataSource
        self.xmlService = xmlService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    // MARK: Private
    
    private func setupView() {
        dataSource.setup(with: tableView)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(willCancel))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(willShare))
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(willSave))
        
        shareButton.isEnabled = !dataSource.words.isEmpty
        saveButton.isEnabled = !dataSource.words.isEmpty
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItems = [shareButton, saveButton]
    }
    
    @IBAction private func openWordAlertController(_ sender: UIBarButtonItem) {
        router?.wantsToOpenWordEditor(with: .new)
    }
    
    @objc private func willShare() {
        let xml = xmlService.writeList(with: dataSource.words)
        let filename = "\(dataSource.title).\(FileExtension.list.rawValue)"
        
        do {
            let fileURL = URL(fileURLWithPath: getDocumentsDirectory()).appendingPathComponent(filename)
            try xml.write(to: fileURL, atomically: true, encoding: .utf8)
            
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = view
            present(activityVC, animated: true)
            
        } catch {
            print(error)
        }
    }
    
    @objc private func willCancel() {
        router?.wantsToGoBack()
    }
    
    @objc private func willSave() {
        router?.wantsToSave()
    }
    
    private func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

protocol ListViewControllerDelegate: class {
    
    func updateVisibility(with isEmpty: Bool)
}




// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? ListViewCell,
            let existingWord = cell.word
        else { return }
        
        router?.wantsToOpenWordEditor(with: .edit(existingWord, indexPath.row))
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




// MARK: - WordAlertControllerDelegate

extension ListViewController: WordAlertControllerDelegate {
    
    func addWord(_ word: Word) {
        dataSource.addWord(word)
        
        tableView.beginUpdates()
        
        let indexPath = IndexPath(row: dataSource.lastIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        tableView.endUpdates()
    }
    
    func replaceWord(by newWord: Word, at index: Int) {
        dataSource.replaceWord(by: newWord, at: index)
        
        tableView.beginUpdates()
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        tableView.endUpdates()
    }
}




// MARK: - ListViewControllerDelegate

extension ListViewController: ListViewControllerDelegate {
    
    func updateVisibility(with isEmpty: Bool) {
        navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = !isEmpty }
    }
}




// MARK: - SaveAlertControllerDelegate

extension ListViewController: SaveAlertControllerDelegate {
    
    func save(with title: String) {
        dataSource.save(with: title)
        router?.wantsToGoBack()
    }
}
