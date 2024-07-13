//
//  PDFDocumentRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 04/01/2024.
//

import Foundation
import UIKit
import NefertitiFile

class PDFDocumentRouter: FullScreenRouter {
    public var diskFile: NefertitiFile? = nil
    
    init(applicationState: (DocumentViewerApplicationStateProtocol &
                            FileManagerApplicationStateProtocol &
                            SubscriptionApplicationStateProtocol),
         subscriptionProposalRouter: SubscriptionProposalRouter) {
        self.applicationState = applicationState
        self.subscriptionProposalRouter = subscriptionProposalRouter
        
        super.init()
    }
    
    override func make() -> UIViewController {
        let interactor = PDFDocumentInteractor(applicationState: applicationState,
                                               diskFile: diskFile)
        let presenter = PDFDocumentPresenter(interactor: interactor)
        let viewController = PDFDocumentViewController(presenter: presenter,
                                                       subscriptionProposalRouter: subscriptionProposalRouter)
        
        return fullScreenNavigationController(with: viewController)
    }
    
    private let applicationState: (DocumentViewerApplicationStateProtocol &
                                   FileManagerApplicationStateProtocol &
                                   SubscriptionApplicationStateProtocol)
    let subscriptionProposalRouter: SubscriptionProposalRouter
}
