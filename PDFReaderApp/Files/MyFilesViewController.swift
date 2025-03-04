//
//  ViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 28/12/2023.
//

import UIKit
import PDFKit
import NefertitiFile

class MyFilesViewController: UIViewController {
    
    // MARK: - Definitions
    
    struct Constants {
        struct ScanButtonLayout {
            static let side = 60.0
            static let rightOffset = -15.0
            static let bottomOffset = -20.0
        }
        
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
            static let menuHeight = 320.0
        }
    }
    
    enum Section {
      case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, NefertitiFile>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NefertitiFile>
    
    // MARK: - Properties
    
    let presenter: MyFilesPresenter?
    let pdfDocumentRouter: PDFDocumentRouter?
    let subscriptionProposalRouter: SubscriptionProposalRouter?
    
    lazy var dataSource = makeDataSource()
    
    private let scanButton = UIButton(type: .custom)
    private let importButton = UIButton(type: .custom)
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var signInAutomaticallyRequested = false
    
    let activityView = UIActivityIndicatorView(style: .large)
    
    var subscriptionProposalShown = false
    
    // MARK: - Life Cycle
    
    init(presenter: MyFilesPresenter?,
         pdfDocumentRouter: PDFDocumentRouter,
         subscriptionProposalRouter: SubscriptionProposalRouter) {
        self.presenter = presenter
        self.pdfDocumentRouter = pdfDocumentRouter
        self.subscriptionProposalRouter = subscriptionProposalRouter
        
        super.init(nibName: nil,
                   bundle: nil)
        
        self.title = self.presenter?.title ?? ""
        
        self.presenter?.add(dynamicUI: self)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = nil
        self.pdfDocumentRouter = nil
        self.subscriptionProposalRouter = nil
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupSearchController()
        setupCollectionView()
        setupScanButton()
        setupImportButton()
        
        setupActivityView()
        
        setupConstraints()
        
        if !subscriptionProposalShown {
            presenter?.checkIfSubscribed(subscribedCompletionHandler: {
            }, notSubscribedCompletionHandler: { [weak self] in
                guard let self = self else { return }
                
                self.presentSubscriptionProposal()
            })
        }
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
    
    private func setupScanButton() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: Constants.ScanButtonLayout.side,
                                                              weight: .semibold)
        let scanButtonImage = UIImage(systemName: "document.viewfinder",
                                        withConfiguration: symbolConfiguration)
        
        scanButton.setImage(scanButtonImage, for: .normal)
        scanButton.addTarget(self,
                             action: #selector(scanAction),
                             for: .touchUpInside)
        
        scanButton.layer.cornerRadius = 10
        scanButton.clipsToBounds = true
        scanButton.backgroundColor = .blue
        scanButton.tintColor = .white
        
        view.addSubview(scanButton)
    }
    
    private func setupImportButton() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: Constants.ImportButtonLayout.side,
                                                              weight: .semibold)
        let importButtonImage = UIImage(systemName: "square.and.arrow.down",
                                        withConfiguration: symbolConfiguration)
        
        importButton.setImage(importButtonImage, for: .normal)
        importButton.addTarget(self,
                               action: #selector(importAction),
                               for: .touchUpInside)
        importButton.setPreferredSymbolConfiguration(.init(scale: .large),
                                                     forImageIn: .normal)
        
        importButton.layer.cornerRadius = 10
        importButton.clipsToBounds = true
        importButton.backgroundColor = .blue
        importButton.tintColor = .white
        
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
        
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        scanButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                            constant: Constants.ScanButtonLayout.rightOffset).isActive = true
        scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                             constant: Constants.ScanButtonLayout.bottomOffset).isActive = true
        scanButton.widthAnchor.constraint(equalToConstant: Constants.ScanButtonLayout.side).isActive = true
        scanButton.heightAnchor.constraint(equalToConstant: Constants.ScanButtonLayout.side).isActive = true
        
        importButton.translatesAutoresizingMaskIntoConstraints = false
        importButton.rightAnchor.constraint(equalTo: scanButton.leftAnchor,
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
    
    @objc private func scanAction() {
        startScanning()
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
    
    // MARK: - Update UI
    
    func hideDocumentCamera() {
        if documentCameraViewController != nil {
            navigationController?.dismiss(animated: true)
            documentCameraViewController = nil
        }
    }
    
    func showJustScannedFileIfExists() {
        if let lastScannedFile = presenter?.lastScannedFile as? NefertitiFile {
            self.pdfDocumentRouter?.diskFile = lastScannedFile
            
            presenter?.removeLastScannedFile()
            
            guard let pdfDocumentViewController = pdfDocumentRouter?.make() else { return }
            
            navigationController?.present(pdfDocumentViewController,
                                          animated: true)
        }
    }
    
    func presentSubscriptionProposal() {
        guard let subscriptionViewController = subscriptionProposalRouter?.make() else {
            return
        }
        
        navigationController?.present(subscriptionViewController,
                                      animated: true)
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        let files = presenter?.sortedAndFilteredFiles(for: searchController.searchBar.text) as? [NefertitiFile] ?? []
        snapshot.appendItems(files)
        dataSource.apply(snapshot,
                         animatingDifferences: true)
    }
    
    private func initiateRename(of file: NefertitiFile) {
        let alert = UIAlertController(title: String(localized: "fileRename"),
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = file.title
        }
        
        let renameAction = UIAlertAction(title: "ok",
                                         style: .default,
                                         handler: { [weak self, weak alert] _ in
            guard let textFields = alert?.textFields,
                  textFields.count > 0 else { return }
            
            let textField = textFields[0]
            
            guard let newTitle = textField.text else { return }
            
            if newTitle != file.title {
                self?.presenter?.rename(file.id, to: newTitle)
                self?.applySnapshot()
            }
        })
        
        let cancelAction = UIAlertAction(title: String(localized:"cancel"),
                                         style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        alert.addAction(renameAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentActionSheet(forFile file: NefertitiFile) {
        var alertStyle = UIAlertController.Style.actionSheet
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: alertStyle)
        
        let pdfDocumentDataUrl = file.documentDataUrl
        
        let renameAction = UIAlertAction(title: String(localized: "rename"),
                                         style: .default,
                                         handler: { [weak self] (action: UIAlertAction) -> Void in
            self?.initiateRename(of: file)
        })
        
        let shareAction = UIAlertAction(title: String(localized: "share"),
                                        style: .default,
                                        handler: { [weak self] (action: UIAlertAction) -> Void in
            guard let self = self, let pdfDocumentDataUrl = pdfDocumentDataUrl else { return }
            
            let activityViewController = UIActivityViewController(activityItems: [pdfDocumentDataUrl],
                                                                  applicationActivities: nil)
            self.present(activityViewController,
                         animated: true,
                         completion: nil)
        })
        
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
        
        alertController.addAction(renameAction)
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    private func filesActionsInfoView(forFile file: NefertitiFile) -> FileInfoView {
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
    
    // MARK: - Scanning
    
    private var documentCameraViewController: UIViewController? = nil
    
    private func startScanning() {
        guard isDocumentCameraSupported else {
            let cameraNotSupportedAlert = errorAlert(withMessage: String(localized: "documentCameraNotSupported"))
            
            self.present(cameraNotSupportedAlert, animated: true, completion: nil)
            
            return
        }
        
        documentCameraViewController = presenter?.documentCameraRouter().make()
        
        presenter?.add(dynamicUI: self)
        
        if let documentCameraViewController = documentCameraViewController {
            navigationController?.present(documentCameraViewController,
                                          animated: true)
        }
    }
    
    private var isDocumentCameraSupported: Bool {
        return presenter?.isDocumentCameraSupported ?? false
    }
}
