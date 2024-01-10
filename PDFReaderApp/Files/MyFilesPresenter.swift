//
//  MyFilesPresenter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 30/12/2023.
//

import Foundation
import UIKit
import PDFKit

class MyFilesPresenter: PresenterProtocol {
    private let interactor: MyFilesInteractor
    
    private let documentPickerManager: DocumentPickerManager
    
    let title: String
    
    var documentPickerViewController: UIDocumentPickerViewController? {
        return documentPickerManager.documentPickerViewController
    }
    
    init(interactor: MyFilesInteractor,
         documentImportManager: DocumentImportManagerProtocol,
         title: String) {
        self.interactor = interactor
        self.documentPickerManager = DocumentPickerManager(documentImportManager: documentImportManager)
        self.title = title
    }
    
    func add(dynamicUI: DynamicUIProtocol) {
        documentPickerManager.add(dynamicUI: dynamicUI)
    }
    
    func remove(dynamicUI: DynamicUIProtocol) {
        documentPickerManager.remove(dynamicUI: dynamicUI)
    }
    
    func sortedAndFilteredFiles(for queryOrNil: String?) -> [any FileProtocol] {
        return interactor.sortedAndFilteredFiles(for: queryOrNil)
    }
    
    func deleteFile(withId fileId: UUID) {
        interactor.deleteFile(withId: fileId)
    }
    
    func pdfDocumentThumbnail(ofSize thumbnailSize: CGSize,
                              forFile file: DiskFile,
                              completionHandler: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let pdfDocument = PDFDocument(data: file.data)
            let pdfDocumentPage = pdfDocument?.page(at: 0)
            
            DispatchQueue.main.async {
                completionHandler(pdfDocumentPage?.thumbnail(of: thumbnailSize,
                                                             for: PDFDisplayBox.trimBox))
            }
        }
    }
}
