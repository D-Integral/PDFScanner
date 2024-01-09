//
//  PDFDocumentViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/01/2024.
//

import UIKit
import PDFKit

class PDFDocumentViewController: DocumentViewController {
    
    // MARK: - Constants
    
    struct Constants {
        struct SearchResults {
            static let fontSize = 14.0
            static let spacing = 5.0
            static let bottonOffset = 15.0
            static let cornerRadius = 20.0
            static let buttonSide = 50.0
            static let animationDuration = 0.25
        }
    }
    
    // MARK: - Properties
    
    let presenter: PDFDocumentPresenter?
    
    private let pdfView = PDFView()
    
    let activityView = UIActivityIndicatorView(style: .large)
    
    private let previousSearchResultButton = UIButton(type: .system)
    private let nextSearchResultButton = UIButton(type: .system)
    private let searchResultsInfoLabel = UILabel(frame: .zero)
    private var searchResultsViewBottomConstraint: NSLayoutConstraint? = nil
    
    var searchResultsCount: Int {
        return presenter?.searchResultsCount ?? 0
    }
    
    var currentSearchResultIndex: Int {
        return presenter?.currentSearchResultIndex ?? 0
    }
    
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
        setupSearchResultsView()
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name:UIResponder.keyboardWillChangeFrameNotification,
                                               object: self.view.window)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: self.view.window)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: self.view.window)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: self.view.window)
    }
    
    // MARK: - Search
    
    override func search() {
        presenter?.resetSearchResults()
        presenter?.search(withQuery: searchController.searchBar.text)
    }
    
    func showHideSearchResults() {
        pdfView.highlightedSelections = presenter?.searchResults
        
        searchResultsView.isHidden = searchResultsCount == 0
        
        updateSearchResultsInfoLabelText()
    }
    
    func updateSearchResultsInfoLabelText() {
        searchResultsInfoLabel.text = String(localized: "\(currentSearchResultIndex) of \(searchResultsCount) Search Results")
    }
    
    func showCurrentSearchResult() {
        if let currentSearchResult = presenter?.currentSearchResult {
            pdfView.go(to: currentSearchResult)
            pdfView.setCurrentSelection(currentSearchResult,
                                        animate: true)
        }
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
    
    private func setupPreviousSearchResultButton() {
        previousSearchResultButton.setImage(UIImage(systemName: "arrow.backward.circle.fill"),
                                            for: .normal)
        previousSearchResultButton.addTarget(self, action: #selector(previousSearchResultAction),
                                             for: .touchUpInside)
    }
    
    private func setupNextSearchResultButton() {
        nextSearchResultButton.setImage(UIImage(systemName: "arrow.forward.circle.fill"),
                                        for: .normal)
        nextSearchResultButton.addTarget(self,
                                         action: #selector(nextSearchResultAction),
                                         for: .touchUpInside)
    }
    
    private func setupSearchResultsInfoLabel() {
        searchResultsInfoLabel.numberOfLines = 2
        searchResultsInfoLabel.textColor = .label
        searchResultsInfoLabel.font = .systemFont(ofSize: Constants.SearchResults.fontSize)
        searchResultsInfoLabel.textAlignment = .center
        
        searchResultsInfoLabel.text = "0 of 0 Search Results"
    }
    
    private func setupSearchResultsView() {
        searchResultsView.isHidden = true
        
        searchResultsView.backgroundColor = .systemBackground
        searchResultsView.axis = .horizontal
        searchResultsView.spacing = Constants.SearchResults.spacing
        searchResultsView.layer.cornerRadius = Constants.SearchResults.cornerRadius
        
        setupPreviousSearchResultButton()
        searchResultsView.addArrangedSubview(previousSearchResultButton)
        
        setupSearchResultsInfoLabel()
        searchResultsView.addArrangedSubview(searchResultsInfoLabel)
        
        setupNextSearchResultButton()
        searchResultsView.addArrangedSubview(nextSearchResultButton)
        
        view.addSubview(searchResultsView)
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
        
        previousSearchResultButton.translatesAutoresizingMaskIntoConstraints = false
        previousSearchResultButton.widthAnchor.constraint(equalToConstant: Constants.SearchResults.buttonSide).isActive = true
        previousSearchResultButton.heightAnchor.constraint(equalToConstant: Constants.SearchResults.buttonSide).isActive = true
        
        searchResultsInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        searchResultsInfoLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        searchResultsInfoLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        nextSearchResultButton.translatesAutoresizingMaskIntoConstraints = false
        nextSearchResultButton.widthAnchor.constraint(equalToConstant: Constants.SearchResults.buttonSide).isActive = true
        nextSearchResultButton.heightAnchor.constraint(equalToConstant: Constants.SearchResults.buttonSide).isActive = true
        
        searchResultsView.translatesAutoresizingMaskIntoConstraints = false
        searchResultsView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        searchResultsViewBottomConstraint = searchResultsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                                      constant: -Constants.SearchResults.bottonOffset)
        searchResultsViewBottomConstraint?.isActive = true
        searchResultsView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        searchResultsView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // MARK: - Actions
    
    @objc private func previousSearchResultAction() {
        presenter?.decrementCurrentSearchResultIndex()
        updateSearchResultsInfoLabelText()
        showCurrentSearchResult()
    }
    
    @objc private func nextSearchResultAction() {
        presenter?.incrementCurrentSearchResultIndex()
        updateSearchResultsInfoLabelText()
        showCurrentSearchResult()
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardWillHide() {
        self.searchResultsViewBottomConstraint?.constant = -Constants.SearchResults.bottonOffset
        
        UIView.animate(withDuration: Constants.SearchResults.animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillChange(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.searchResultsViewBottomConstraint?.constant = -(Constants.SearchResults.bottonOffset + keyboardSize.height)
        
        UIView.animate(withDuration: Constants.SearchResults.animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
