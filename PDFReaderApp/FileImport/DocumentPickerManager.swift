//
//  DocumentPickerDelegate.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 31/12/2023.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

final class DocumentPickerManager: DynamicUINotifier {
    let documentImportManager: DocumentImportManagerProtocol
    var documentPickerViewController: UIDocumentPickerViewController? = nil
    
    init(documentImportManager: DocumentImportManagerProtocol) {
        self.documentImportManager = documentImportManager
        
        super.init()
        
        setupDocumentPickerViewController()
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
    
    // MARK: Helpers
    
    private func tempUrl(for fileName: String) -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
    }
}
