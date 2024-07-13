//
//  ScanViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 28/12/2023.
//

import UIKit
import VisionKit
import NefertitiFile

class ScanningViewController: UIViewController {
    
    // MARK: - Public Interface
    
    public init(presenter: ScanningPresenter,
                pdfDocumentRouter: PDFDocumentRouter) {
        self.presenter = presenter
        self.pdfDocumentRouter = pdfDocumentRouter
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = nil
        self.pdfDocumentRouter = nil
        
        super.init(coder: coder)
    }
    
    // MARK: - Properties
    
    private let presenter: ScanningPresenter?
    let pdfDocumentRouter: PDFDocumentRouter?
    
    private let startScanningButton = UIButton(type: .system)
    private let documentCameraNotSupportedLabel = UILabel(frame: .zero)
    
    let activityView = UIActivityIndicatorView(style: .large)
    
    private var isDocumentCameraSupported: Bool {
        return presenter?.isDocumentCameraSupported ?? false
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupDocumentCameraNotSupportedLabel()
        setupStartScanButton()
        
        setupActivityView()
        
        setupConstraints()
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
            
            guard let pdfDocumentViewController = pdfDocumentRouter?.make() else { return }
            
            navigationController?.present(pdfDocumentViewController,
                                          animated: true)
        }
    }
    
    // MARK: - Setup
    
    private func setupStartScanButton() {
        startScanningButton.setTitle(String(localized: "startScanButtonTitle"),
                              for: .normal)
        startScanningButton.titleLabel?.textAlignment = .center
        startScanningButton.addTarget(self,
                                  action: #selector(startScanningAction),
                                  for: .touchUpInside)
        startScanningButton.isHidden = !isDocumentCameraSupported
        
        view.addSubview(startScanningButton)
    }
    
    private func setupDocumentCameraNotSupportedLabel() {
        documentCameraNotSupportedLabel.text = String(localized: "documentCameraNotSupported")
        documentCameraNotSupportedLabel.textAlignment = .center
        documentCameraNotSupportedLabel.isHidden = isDocumentCameraSupported
        
        view.addSubview(documentCameraNotSupportedLabel)
    }
    
    private func setupActivityView() {
        activityView.center = view.center
        
        view.addSubview(activityView)
    }
    
    private func setupConstraints() {
        startScanningButton.translatesAutoresizingMaskIntoConstraints = false
        startScanningButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        startScanningButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        startScanningButton.setContentHuggingPriority(.defaultHigh,
                                                  for: .vertical)
        startScanningButton.setContentHuggingPriority(.defaultHigh,
                                                  for: .horizontal)
        
        documentCameraNotSupportedLabel.translatesAutoresizingMaskIntoConstraints = false
        documentCameraNotSupportedLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        documentCameraNotSupportedLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        documentCameraNotSupportedLabel.setContentHuggingPriority(.defaultHigh,
                                                                  for: .vertical)
        documentCameraNotSupportedLabel.setContentHuggingPriority(.defaultHigh,
                                                                  for: .horizontal)
    }

    // MARK: - Actions
    
    @objc private func startScanningAction() {
        startScanning()
    }
    
    // MARK: - Private Functions
    
    var documentCameraViewController: UIViewController? = nil
    
    private func startScanning() {
        documentCameraViewController = presenter?.documentCameraRouter().make()
        
        presenter?.add(dynamicUI: self)
        
        if let documentCameraViewController = documentCameraViewController {
            navigationController?.present(documentCameraViewController,
                                          animated: true)
        }
    }
}
