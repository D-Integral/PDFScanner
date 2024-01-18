//
//  ScanningRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import UIKit

class ScanningRouter: RouterProtocol {
    
    // MARK: Public Interface
    
    public init(applicationState: (DocumentScannerApplicationStateProtocol & DynamicUINotifierProtocol),
                pdfDocumentRouter: PDFDocumentRouter) {
        self.applicationState = applicationState
        self.pdfDocumentRouter = pdfDocumentRouter
    }
    
    func make() -> UIViewController {
        let interactor = ScanningInteractor(applicationState: applicationState)
        let presenter = ScanningPresenter(interactor: interactor)
        
        return ScanningViewController(presenter: presenter,
                                      pdfDocumentRouter: pdfDocumentRouter)
    }
    
    // MARK: - Private Properties
    
    private let applicationState: (DocumentScannerApplicationStateProtocol & DynamicUINotifierProtocol)
    private let pdfDocumentRouter: PDFDocumentRouter
}
