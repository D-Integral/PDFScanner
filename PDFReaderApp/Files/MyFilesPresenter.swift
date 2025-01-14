//
//  MyFilesPresenter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 30/12/2023.
//

import Foundation
import UIKit
import PDFKit
import NefertitiFile

class MyFilesPresenter: PresenterProtocol {
    private let interactor: MyFilesInteractor
    
    let title: String
    
    var documentPickerViewController: UIDocumentPickerViewController? {
        return interactor.documentPickerManager.documentPickerViewController
    }
    
    init(interactor: MyFilesInteractor,
         title: String) {
        self.interactor = interactor
        self.title = title
    }
    
    func add(dynamicUI: DynamicUIProtocol) {
        interactor.add(dynamicUI: dynamicUI)
    }
    
    func remove(dynamicUI: DynamicUIProtocol) {
        interactor.remove(dynamicUI: dynamicUI)
    }
    
    func sortedAndFilteredFiles(for queryOrNil: String?) -> [any NefertitiFileProtocol] {
        return interactor.sortedAndFilteredFiles(for: queryOrNil)
    }
    
    func deleteFile(withId fileId: UUID) {
        interactor.deleteFile(withId: fileId)
    }
    
    func openedFile(withId fileId: UUID) {
        interactor.openedFile(withId: fileId)
    }
    
    public func rename(_ fileId: UUID, to newName: String) {
        interactor.rename(fileId, to: newName)
    }
    
    func pdfDocumentThumbnail(forFile file: NefertitiFile,
                              completionHandler: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let documentPreviewData = file.thumbnailData else {
                
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                return
            }
            
            let previewImage = UIImage(data: documentPreviewData)
            
            DispatchQueue.main.async {
                completionHandler(previewImage)
            }
        }
    }
    
    // MARK: - Scanning
    
    public func documentCameraRouter() -> RouterProtocol {
        return interactor.documentCameraRouter()
    }
    
    public var isDocumentCameraSupported: Bool {
        return interactor.isDocumentCameraSupported
    }
    
    public var lastScannedFile: (any NefertitiFileProtocol)? {
        return interactor.lastScannedFile
    }
    
    func checkIfSubscribed(subscribedCompletionHandler: () -> (),
                           notSubscribedCompletionHandler: () -> ()) {
        interactor.checkIfSubscribed(subscribedCompletionHandler: subscribedCompletionHandler,
                                     notSubscribedCompletionHandler: notSubscribedCompletionHandler)
    }
}
