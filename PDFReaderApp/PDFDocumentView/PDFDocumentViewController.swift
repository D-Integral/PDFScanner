//
//  PDFDocumentViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/01/2024.
//

import UIKit
import PDFKit

class PDFDocumentViewController: DocumentViewController {
    
    // MARK: - Properties
    
    let presenter: PDFDocumentPresenter?
    
    let pdfView = PDFView()
    
    let activityView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life Cycle
    
    init(presenter: PDFDocumentPresenter?) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = self.presenter?.title ?? ""
        
        presenter?.add(dynamicUI: self)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = nil
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPdfView()
        
        setupActivityView()
        
        setupConstraints()
    }
    
    // MARK: - Search
    
    
    override func updateSearchResults() {
        presenter?.resetSearchResults()
        presenter?.search(withQuery: searchController.searchBar.text)
    }
    
    // MARK: - Setup
    
    private func setupPdfView() {
        pdfView.document = presenter?.pdfDocument
        pdfView.autoresizesSubviews = true
        pdfView.displayDirection = .vertical
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displaysPageBreaks = true
        pdfView.displaysAsBook = true
        
        view.addSubview(pdfView)
    }
    
    private func setupActivityView() {
        activityView.center = view.center
        
        view.addSubview(activityView)
    }
    
    private func setupConstraints() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
}
