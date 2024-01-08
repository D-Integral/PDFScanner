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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupDismissNavBarGestureRecognizer()
        setupSearchController()
    }
    
    // MARK: - Search
    
    func updateSearchResults() { }
    
    var searchBarPlaceholderText: String {
        return String(localized: "search")
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = closeBarButtonItem()
        navigationItem.rightBarButtonItem = searchBarButtonItem()
    }
    
    private func setupDismissNavBarGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(dismissNavBarAction))
        tapGestureRecognizer.cancelsTouchesInView = false
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
