//
//  MyFilesRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 31/12/2023.
//

import Foundation
import UIKit

class MyFilesRouter: RouterProtocol {
    init(applicationState: (FileManagerApplicationStateProtocol & DynamicUINotifierProtocol),
         pdfDocumentRouter: PDFDocumentRouter) {
        self.applicationState = applicationState
        self.pdfDocumentRouter = pdfDocumentRouter
    }
    
    func make() -> UIViewController {
        let documentImportManager = PDFDocumentImportManager(applicationState: applicationState)
        let interactor = MyFilesInteractor(applicationState: applicationState,
                                           documentImportManager: documentImportManager)
        let presenter = MyFilesPresenter(interactor: interactor,
                                         title: String(localized: "myFilesViewControllerTitle"))
        
        return MyFilesViewController(presenter: presenter,
                                     pdfDocumentRouter: pdfDocumentRouter)
    }
    
    let applicationState: (FileManagerApplicationStateProtocol & DynamicUINotifierProtocol)
    let pdfDocumentRouter: PDFDocumentRouter
}
