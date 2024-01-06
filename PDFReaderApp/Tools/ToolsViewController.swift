//
//  ToolsViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 28/12/2023.
//

import UIKit

class ToolsViewController: UIViewController {
    
    let presenter: ToolsPresenter?
    
    init(presenter: ToolsPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = nil
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

}
