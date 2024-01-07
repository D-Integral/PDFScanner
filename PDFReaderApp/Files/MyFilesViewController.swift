//
//  ViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 28/12/2023.
//

import UIKit
import PDFKit

class MyFilesViewController: UIViewController {
    
    // MARK: - Definitions
    
    struct Constants {
        struct ImportButtonLayout {
            static let side = 60.0
            static let rightOffset = -15.0
            static let bottomOffset = -20.0
        }
        
        struct FilesList {
            struct Layout {
                static let contentInset = 12.0
                static let cellContentInset = 3.0
                static let narrowScreenColumnsCount = 3
                static let wideScreenColumnsCount = 4
                static let cellHeight = 182.0
            }
            
            struct Reuse {
                static let cellIdentifier = "MyFilesCollectionViewCell"
            }
        }
    }
    
    enum Section {
      case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DiskFile>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiskFile>
    
    // MARK: - Properties
    
    let presenter: MyFilesPresenter?
    
    lazy var dataSource = makeDataSource()
    
    private let importButton = UIButton(type: .custom)
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    private var searchController = UISearchController(searchResultsController: nil)
    private var pleaseSignInLabel = UILabel(frame: .zero)
    
    private var signInAutomaticallyRequested = false
    
    private var userLogged: Bool {
        return presenter?.userLogged ?? false
    }
    
    private var automaticSignInRequestNeeded: Bool {
        return !signInAutomaticallyRequested && !userLogged
    }
    
    let activityView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life Cycle
    
    init(presenter: MyFilesPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil,
                   bundle: nil)
        
        self.title = presenter.title
        
        self.presenter?.add(dynamicUI: self)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = nil
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupPleaseSignInLabel()
        setupSearchController()
        setupCollectionView()
        setupImportButton()
        setupActivityView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUIAccordingToUserLogInStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        automaticallyRequestSignInIfNeeded()
    }
    
    // MARK: - Collection View
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [ weak self] (sectionIndex: Int,
                                                                         layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            let width = layoutEnvironment.container.effectiveContentSize.width
            let defaultColumnsCount = Constants.FilesList.Layout.narrowScreenColumnsCount
            let columnsCount = self?.columnsCount(forViewWidth: width) ?? defaultColumnsCount
            let heightDimension = NSCollectionLayoutDimension.estimated(Constants.FilesList.Layout.cellHeight)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/CGFloat(columnsCount)),
                                                  heightDimension: heightDimension)
            let documentItem = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: heightDimension)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           repeatingSubitem: documentItem,
                                                           count: columnsCount)
            
            return NSCollectionLayoutSection(group: group)
        }
        return layout
    }
    
    func columnsCount(forViewWidth viewWidth: Double) -> Int {
        let narrowScreenColumnsCount = Constants.FilesList.Layout.narrowScreenColumnsCount
        let wideScreenColumnsCount = Constants.FilesList.Layout.wideScreenColumnsCount
        return viewWidth > 500.0 ? wideScreenColumnsCount : narrowScreenColumnsCount
    }
    
    // MARK: - Setup
    
    private func setupPleaseSignInLabel() {
        pleaseSignInLabel.text = String(localized: "Please Sign In")
        pleaseSignInLabel.textAlignment = .center
        
        view.addSubview(pleaseSignInLabel)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = String(localized: "searchPdfDocuments")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = collectionViewLayout()
        collectionView.register(MyFilesCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.FilesList.Reuse.cellIdentifier)
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func setupImportButton() {
        let importButtonImage = UIImage(named: "button_import") as UIImage?
        
        importButton.setImage(importButtonImage, for: .normal)
        importButton.addTarget(self,
                               action: #selector(importAction),
                               for: .touchUpInside)
        view.addSubview(importButton)
    }
    
    private func setupActivityView() {
        activityView.center = view.center
        
        view.addSubview(activityView)
    }
    
    private func setupConstraints() {
        pleaseSignInLabel.translatesAutoresizingMaskIntoConstraints = false
        pleaseSignInLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        pleaseSignInLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        pleaseSignInLabel.setContentHuggingPriority(.defaultHigh,
                                                    for: .vertical)
        pleaseSignInLabel.setContentHuggingPriority(.defaultHigh,
                                                    for: .horizontal)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: Constants.FilesList.Layout.contentInset).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -Constants.FilesList.Layout.contentInset).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -Constants.FilesList.Layout.contentInset).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: Constants.FilesList.Layout.contentInset).isActive = true
        
        importButton.translatesAutoresizingMaskIntoConstraints = false
        importButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                            constant: Constants.ImportButtonLayout.rightOffset).isActive = true
        importButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                             constant: Constants.ImportButtonLayout.bottomOffset).isActive = true
        importButton.widthAnchor.constraint(equalToConstant: Constants.ImportButtonLayout.side).isActive = true
        importButton.heightAnchor.constraint(equalToConstant: Constants.ImportButtonLayout.side).isActive = true
    }
    
    // MARK: - Actions
    
    @objc private func importAction() {
        guard let documentPicker = presenter?.documentPickerViewController else { return }
        
        self.present(documentPicker,
                     animated: true,
                     completion: nil)
    }
    
    // MARK: - Private Functions
    
    private func makeDataSource() -> DataSource {
      let dataSource = DataSource(collectionView: collectionView,
                                  cellProvider: { [weak self] (collectionView, indexPath, diskFile) -> UICollectionViewCell? in
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.FilesList.Reuse.cellIdentifier,
                                                        for: indexPath) as? MyFilesCollectionViewCell
          cell?.diskFile = diskFile
          cell?.moreActionBlock = { [weak self] diskFile in
              guard let id = diskFile?.id else { return }
              
              self?.presentActionSheet(forFileId: id)
          }
          
          let thumbnailSize = MyFilesCollectionViewCell.Constants.Thumbnail.size
          self?.presenter?.pdfDocumentThumbnail(ofSize: thumbnailSize,
                                                forFile: diskFile,
                                                completionHandler: { thumbnailImage in
              cell?.thumbnail = thumbnailImage
          })
          
          return cell
      })
        
      return dataSource
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        let files = presenter?.sortedAndFilteredFiles(for: searchController.searchBar.text) as? [DiskFile] ?? []
        snapshot.appendItems(files)
        dataSource.apply(snapshot,
                         animatingDifferences: true)
    }
    
    func updateVisibility() {
        let loggedIn = userLogged
        
        pleaseSignInLabel.isHidden = loggedIn
        
        for loggedInView in [searchController.searchBar, collectionView, importButton] {
            loggedInView.isHidden = !userLogged
        }
    }
    
    private func presentActionSheet(forFileId fileId: UUID) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: String(localized: "delete"),
                                         style: .destructive,
                                         handler: { [weak self] (action: UIAlertAction) -> Void in
            self?.presenter?.deleteFile(withId: fileId)
            self?.updateDynamicUI()
        })
        
        let cancelAction = UIAlertAction(title: String(localized:"cancel"),
                                         style: .default,
                                         handler: {(action: UIAlertAction) -> Void in
            self.dismiss(animated: true)
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    private func errorAlert(withMessage message: String) -> UIAlertController {
        let alert = UIAlertController(title: String(localized: "error"),
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        
        return alert
    }
    
    private func automaticallyRequestSignInIfNeeded() {
        if automaticSignInRequestNeeded {
            signInAutomaticallyRequested = true
            signInViaGoogleAccount()
        }
    }
    
    // MARK: - Sign In via Google Account
    
    private func signInViaGoogleAccount() {
        activityView.startAnimating()
        
        presenter?.signIn(withServiceProvider: .Google,
                         completionHandler: { [weak self] user, error in
            guard let self = self else { return }
            
            self.activityView.stopAnimating()
            
            if let error = error {
                self.present(self.errorAlert(withMessage: error.localizedDescription),
                             animated: true,
                             completion: nil)
            }
            
            self.updateUIAccordingToUserLogInStatus()
        })
    }
    
    private func updateUIAccordingToUserLogInStatus() {
        self.updateVisibility()
        self.updateDynamicUI()
    }
}
