//
//  AppCoordinator.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation
import UIKit

class AppCoordinator {
    static let shared = AppCoordinator()
    
    let homeTabBarController: HomeTabBarController
    
    let applicationState: ApplicationState
    
    let pdfDocumentRouter: PDFDocumentRouter
    let subscriptionProposalRouter: SubscriptionProposalRouter
    
    private init() {
        homeTabBarController = HomeTabBarController()
        
        let fileStorage = DiskFileStorage()
        let documentCameraManager = VisionDocumentCameraManager(pdfMaker: VisionSearchablePDFMaker(),
                                                                fileStorage: fileStorage)
        let positionKeeper = PDFDocumentPositionKeeper()
        
        applicationState = ApplicationState(fileStorage: fileStorage,
                                            positionKeeper: positionKeeper,
                                            documentCameraManager: documentCameraManager,
                                            subscriptionManager: SubscriptionManager())
        
        subscriptionProposalRouter = SubscriptionProposalRouter(state: applicationState)
        
        pdfDocumentRouter = PDFDocumentRouter(applicationState: applicationState,
                                              subscriptionProposalRouter: subscriptionProposalRouter)
        
        homeTabBarController.viewControllers = [filesNavigationController(),
                                                scanningNavigationController()]
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
    
    func filesNavigationController() -> UINavigationController {
        return navigationController(with: MyFilesRouter(applicationState: applicationState,
                                                        pdfDocumentRouter: pdfDocumentRouter,
                                                        subscriptionProposalRouter: subscriptionProposalRouter).make(),
                                    tabBarItem: filesTabBarItem())
    }
    
    func scanningNavigationController() -> UINavigationController {
        return navigationController(with: ScanningRouter(applicationState: applicationState,
                                                         pdfDocumentRouter: pdfDocumentRouter).make(),
                                    tabBarItem: scanningTabBarItem())
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
