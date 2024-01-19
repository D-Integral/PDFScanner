//
//  DocumentViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 08/01/2024.
//

import Foundation
import UIKit

class DocumentViewController: UIViewController {
    
    // MARK: - Properties
    
    var searchController = UISearchController(searchResultsController: nil)
    let searchResultsView = UIStackView(frame: .zero)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupDismissNavBarGestureRecognizer()
        setupSearchController()
    }
    
    // MARK: - Public Interface
    
    public func rename(to newName: String) { }
    
    // MARK: - Search
    
    func search() { }
    
    var searchBarPlaceholderText: String {
        return String(localized: "search")
    }
    
    // MARK: - Share
    
    public func share() { }
    
    // MARK: - Delete
    
    public func delete() { }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = closeBarButtonItem()
        navigationItem.rightBarButtonItem = searchBarButtonItem()
        
        navigationItem.renameDelegate = self
        
        navigationItem.titleMenuProvider = { [weak self] suggestions in
            var finalMenuElements = suggestions
            let shareCommand = UICommand(title: String(localized: "share"),
                                         image: UIImage(systemName: "square.and.arrow.up"),
                                         action: #selector(self?.shareAction))
            let deleteCommand = UICommand(title: String(localized: "delete"),
                                          image: UIImage(systemName: "trash"),
                                          action: #selector(self?.deleteAction),
                                          attributes: [.destructive])
            
            finalMenuElements.append(contentsOf: [shareCommand, deleteCommand])

            
            return UIMenu(children: finalMenuElements)
        }
    }
    
    private func setupDismissNavBarGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(dismissNavBarAction))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchBarPlaceholderText
        
        navigationItem.searchController?.searchBar.isHidden = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Actions
    
    @objc private func closeAction() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func showHideSearchBarAction() {
        navigationItem.searchController = (navigationItem.searchController == nil) ? searchController : nil
        definesPresentationContext = true
    }
    
    @objc private func dismissNavBarAction() {
        guard let isNavigationBarHidden = navigationController?.isNavigationBarHidden else { return }
        
        navigationController?.setNavigationBarHidden(!isNavigationBarHidden, animated: true)
    }
    
    @objc private func shareAction() {
        share()
    }
    
    @objc private func deleteAction() {
        delete()
    }
    
    // MARK: - Private Methods
    
    private func closeBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: .init(systemName: "xmark"),
                               style: .plain,
                               target: self,
                               action: #selector(closeAction))
    }
    
    private func searchBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: .init(systemName: "magnifyingglass"),
                               style: .plain,
                               target: self,
                               action: #selector(showHideSearchBarAction))
    }
}
