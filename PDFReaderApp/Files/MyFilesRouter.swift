//
//  MyFilesRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 31/12/2023.
//

import Foundation
import UIKit

class MyFilesRouter: RouterProtocol {
    init(applicationState: (FileManagerApplicationStateProtocol &
                            DynamicUINotifierProtocol &
                            SubscriptionApplicationStateProtocol),
         pdfDocumentRouter: PDFDocumentRouter,
         subscriptionProposalRouter: SubscriptionProposalRouter) {
        self.applicationState = applicationState
        self.pdfDocumentRouter = pdfDocumentRouter
        self.subscriptionProposalRouter = subscriptionProposalRouter
    }
    
    func make() -> UIViewController {
        let documentImportManager = PDFDocumentImportManager(applicationState: applicationState)
        let interactor = MyFilesInteractor(applicationState: applicationState,
                                           documentImportManager: documentImportManager)
        let presenter = MyFilesPresenter(interactor: interactor,
                                         title: String(localized: "myFilesViewControllerTitle"))
        
        return MyFilesViewController(presenter: presenter,
                                     pdfDocumentRouter: pdfDocumentRouter,
                                     subscriptionProposalRouter: subscriptionProposalRouter)
    }
    
    let applicationState: (FileManagerApplicationStateProtocol &
                           DynamicUINotifierProtocol &
                           SubscriptionApplicationStateProtocol)
    let pdfDocumentRouter: PDFDocumentRouter
    let subscriptionProposalRouter: SubscriptionProposalRouter
}
