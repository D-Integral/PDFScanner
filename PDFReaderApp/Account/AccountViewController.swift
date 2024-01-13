//
//  AccountViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 28/12/2023.
//

import UIKit
import FirebaseCore

class AccountViewController: UIViewController {
    
    // MARK: - Constants
    
    struct Constants {
        struct Layout {
            static let inset = 15.0
        }
    }
    
    // MARK: - Properties
    
    private let presenter: AccountPresenter?
    
    // MARK: - Life Cycle

    init(presenter: AccountPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil,
                   bundle: nil)
        
        self.title = presenter.title
    }
    
    required init?(coder: NSCoder) {
        self.presenter = nil
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupConstraints()
    }
    
    // MARK: - Setup
    
    private func setupConstraints() {
    }
}
