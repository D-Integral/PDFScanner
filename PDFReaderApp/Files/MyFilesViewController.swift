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
                static let fileActionsInfoViewOffset = 15.0
                static let fileActionsInfoViewHeight = 56.0
            }
            
            struct Reuse {
                static let cellIdentifier = "MyFilesCollectionViewCell"
            }
        }
        
        struct FileActions {
            static let infoViewOffset = 15.0
            static let infoViewHeight = 56.0
            static let menuHeight = 200.0
        }
    }
    
    enum Section {
      case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DiskFile>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiskFile>
    
    // MARK: - Properties
    
    let presenter: MyFilesPresenter?
    let pdfDocumentRouter: PDFDocumentRouter?
    
    lazy var dataSource = makeDataSource()
    
    private let importButton = UIButton(type: .custom)
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var signInAutomaticallyRequested = false
    
    let activityView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life Cycle
    
    init(presenter: MyFilesPresenter?,
         pdfDocumentRouter: PDFDocumentRouter) {
        self.presenter = presenter
        self.pdfDocumentRouter = pdfDocumentRouter
        
        super.init(nibName: nil,
                   bundle: nil)
        
        self.title = self.presenter?.title ?? ""
        
        self.presenter?.add(dynamicUI: self)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = nil
        self.pdfDocumentRouter = nil
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupSearchController()
        setupCollectionView()
        setupImportButton()
        
        setupActivityView()
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        applySnapshot()
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
        collectionView.backgroundColor = .systemBackground
        
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
              guard let file = diskFile else { return }
              
              self?.presentActionSheet(forFile: file)
          }
          
          self?.presenter?.pdfDocumentThumbnail(forFile: diskFile,
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
    
    private func presentActionSheet(forFile file: DiskFile) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: String(localized: "delete"),
                                         style: .destructive,
                                         handler: { [weak self] (action: UIAlertAction) -> Void in
            self?.presenter?.deleteFile(withId: file.id)
            self?.updateDynamicUI()
        })
        
        let cancelAction = UIAlertAction(title: String(localized:"cancel"),
                                         style: .default,
                                         handler: {(action: UIAlertAction) -> Void in
            self.dismiss(animated: true)
        })
        
        let filesActionsInfoView = filesActionsInfoView(forFile: file)
        
        alertController.view.addSubview(filesActionsInfoView)
        
        filesActionsInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        filesActionsInfoView.topAnchor.constraint(equalTo: alertController.view.topAnchor,
                                                  constant: Constants.FileActions.infoViewOffset).isActive = true
        filesActionsInfoView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor,
                                                       constant: -Constants.FileActions.infoViewOffset).isActive = true
        filesActionsInfoView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor,
                                                      constant: Constants.FileActions.infoViewOffset).isActive = true
        filesActionsInfoView.heightAnchor.constraint(equalToConstant: Constants.FileActions.infoViewHeight).isActive = true
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: Constants.FileActions.menuHeight).isActive = true
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    private func filesActionsInfoView(forFile file: DiskFile) -> FileInfoView {
        let view = FileInfoView()
        
        view.update(withFile: file)
        
        self.presenter?.pdfDocumentThumbnail(forFile: file,
                                             completionHandler: { thumbnailImage in
            view.thumbnail = thumbnailImage
        })
        
        return view
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
}
