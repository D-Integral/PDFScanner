//
//  DocumentPickerManager+UIDocumentPickerDelegate.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation
import UIKit

extension DocumentPickerManager: UIDocumentPickerDelegate {
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
}
