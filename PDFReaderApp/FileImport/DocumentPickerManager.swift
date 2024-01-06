//
//  DocumentPickerDelegate.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 31/12/2023.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

final class DocumentPickerManager: NSObject, UIDocumentPickerDelegate {
    let documentImportManager: DocumentImportManagerProtocol
    var documentPickerViewController: UIDocumentPickerViewController? = nil
    
    private var dynamicUserInterfaces = [Weak<UIViewController>]()
    
    init(documentImportManager: DocumentImportManagerProtocol) {
        self.documentImportManager = documentImportManager
        
        super.init()
        
        setupDocumentPickerViewController()
    }
    
    func add(dynamicUI: any DynamicUIProtocol) {
        guard let viewController = dynamicUI as? UIViewController else {
            return
        }
        
        dynamicUserInterfaces.append(Weak(value: viewController))
    }
    
    func remove(dynamicUI: any DynamicUIProtocol) {
        guard let viewController = dynamicUI as? UIViewController else {
            return
        }
        
        var index = -1
        
        for (currentIndex, currentWeakDynamicUI) in dynamicUserInterfaces.enumerated() {
            let currentDynamicUI = currentWeakDynamicUI.value
            
            if currentDynamicUI == viewController {
                index = currentIndex
            }
        }
        
        if index >= 0 {
            dynamicUserInterfaces.remove(at: index)
        }
    }
    
    private func updateUI() {
        for weakDynamicUI in Array(dynamicUserInterfaces) {
            guard let viewController = weakDynamicUI.value else {
                continue
            }
            
            viewController.updateDynamicUI()
        }
    }
    
    private func setupDocumentPickerViewController() {
        guard let documentTypeTag = documentImportManager.documentTypeTag else { return }
        
        let types = UTType.types(tag: documentTypeTag,
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil)
        
        documentPickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: types,
                                                                      asCopy: true)
        
        documentPickerViewController?.delegate = self
        documentPickerViewController?.allowsMultipleSelection = true
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentsAt urls: [URL]) {
        timeConsumingOperationStarted()
        
        documentImportManager.importDocuments(at: urls) { [weak self] in
            self?.timeConsumingOperationCompleted()
            self?.updateUI()
        }
    }
    
    // MARK: Helpers
    
    private func tempUrl(for fileName: String) -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
    }
    
    private func timeConsumingOperationStarted() {
        for weakDynamicUI in Array(dynamicUserInterfaces) {
            guard let viewController = weakDynamicUI.value else {
                continue
            }
            
            viewController.timeConsumingOperationStarted()
        }
    }
    
    private func timeConsumingOperationCompleted() {
        for weakDynamicUI in Array(dynamicUserInterfaces) {
            guard let viewController = weakDynamicUI.value else {
                continue
            }
            
            viewController.timeConsumingOperationCompleted()
        }
    }
}
