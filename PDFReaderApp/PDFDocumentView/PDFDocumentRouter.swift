//
//  PDFDocumentRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 04/01/2024.
//

import Foundation
import UIKit

class PDFDocumentRouter: FullScreenRouter {
    public var diskFile: DiskFile? = nil
    
    init(applicationState: (DocumentViewerApplicationStateProtocol & FileManagerApplicationStateProtocol)) {
        self.applicationState = applicationState
        
        super.init()
    }
    
    override func make() -> UIViewController {
        let interactor = PDFDocumentInteractor(applicationState: applicationState,
                                               diskFile: diskFile)
        let presenter = PDFDocumentPresenter(interactor: interactor)
        let viewController = PDFDocumentViewController(presenter: presenter)
        
        return fullScreenNavigationController(with: viewController)
    }
    
    private let applicationState: (DocumentViewerApplicationStateProtocol & FileManagerApplicationStateProtocol)
}
