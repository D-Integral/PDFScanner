//
//  AppCoordinator.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation
import UIKit
import Nefertiti

class AppCoordinator {
    static let shared = AppCoordinator()
    
    var rootViewController: UIViewController? = nil
    
    let applicationState: ApplicationState
    
    let pdfDocumentRouter: PDFDocumentRouter
    let subscriptionProposalRouter: SubscriptionProposalRouter
    
    private init() {
        let fileStorage = DiskFileStorage()
        let documentCameraManager = VisionDocumentCameraManager(pdfMaker: NefertitiSearchablePDFMaker(),
                                                                fileStorage: fileStorage)
        let positionKeeper = PDFDocumentPositionKeeper()
        
        applicationState = ApplicationState(fileStorage: fileStorage,
                                            positionKeeper: positionKeeper,
                                            documentCameraManager: documentCameraManager,
                                            subscriptionManager: SubscriptionManager())
        
        subscriptionProposalRouter = SubscriptionProposalRouter(state: applicationState)
        
        pdfDocumentRouter = PDFDocumentRouter(applicationState: applicationState,
                                              subscriptionProposalRouter: subscriptionProposalRouter)
        
        self.rootViewController = filesNavigationController()
    }
    
    // MARK: Navigation controllers

    func navigationController(with viewController: UIViewController,
                              tabBarItem: UITabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = tabBarItem
        
        return navigationController
    }
    
    func filesNavigationController() -> UIViewController {
        return navigationController(with: MyFilesRouter(applicationState: applicationState,
                                                        pdfDocumentRouter: pdfDocumentRouter,
                                                        subscriptionProposalRouter: subscriptionProposalRouter).make(),
                                    tabBarItem: filesTabBarItem())
    }
    
    // MARK: Tab bar items
    
    func filesTabBarItem() -> UITabBarItem {
        return tabBarItem(withTitle: String(localized: "filesTabBarItemTitle"),
                          image: UIImage(systemName: "folder"))
    }
    
    func scanningTabBarItem() -> UITabBarItem {
        return tabBarItem(withTitle: String(localized: "scan"),
                          image: UIImage(systemName: "doc.viewfinder"))
    }
    
    func tabBarItem(withTitle title: String,
                    image: UIImage?,
                    selectedImage: UIImage? = nil) -> UITabBarItem {
        return UITabBarItem(title: title,
                            image: image,
                            selectedImage: selectedImage)
    }
}
