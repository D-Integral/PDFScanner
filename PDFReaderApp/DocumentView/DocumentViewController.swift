//
//  DocumentViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 08/01/2024.
//

import Foundation
import UIKit

class DocumentViewController: UIViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupDismissNavBarGestureRecognizer()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        let closeBarButtonItem = UIBarButtonItem(image: .init(systemName: "xmark"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(closeAction))

        navigationItem.rightBarButtonItem = closeBarButtonItem
    }
    
    private func setupDismissNavBarGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(dismissNavBarAction))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc private func closeAction() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func dismissNavBarAction() {
        guard let isNavigationBarHidden = navigationController?.isNavigationBarHidden else { return }
        
        navigationController?.setNavigationBarHidden(!isNavigationBarHidden, animated: true)
    }
}
