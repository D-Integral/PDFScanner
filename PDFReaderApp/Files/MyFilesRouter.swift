//
//  MyFilesRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 31/12/2023.
//

import Foundation
import UIKit

class MyFilesRouter: RouterProtocol {
    init(fileStorage: FileStorageProtocol,
         documentCameraManager: DocumentCameraManagerProtocol? = nil,
         pdfDocumentRouter: PDFDocumentRouter) {
        self.fileStorage = fileStorage
        self.documentCameraManager = documentCameraManager
        self.pdfDocumentRouter = pdfDocumentRouter
    }
    
    func make() -> UIViewController {
        let documentImportManager = PDFDocumentImportManager(fileStorage: fileStorage)
        let interactor = MyFilesInteractor(fileStorage: fileStorage,
                                           documentImportManager: documentImportManager,
                                           documentCameraManager: documentCameraManager)
        let presenter = MyFilesPresenter(interactor: interactor,
                                         title: String(localized: "myFilesViewControllerTitle"))
        
        return MyFilesViewController(presenter: presenter,
                                     pdfDocumentRouter: pdfDocumentRouter)
    }
    
    let fileStorage: FileStorageProtocol
    let documentCameraManager: DocumentCameraManagerProtocol?
    let pdfDocumentRouter: PDFDocumentRouter
}
