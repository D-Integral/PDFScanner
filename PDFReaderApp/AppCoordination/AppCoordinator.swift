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
    
    let fileStorage: FileStorageProtocol
    let documentCameraManager: DocumentCameraManagerProtocol
    let positionKeeper: PDFDocumentPositionKeeper
    let pdfDocumentRouter: PDFDocumentRouter
    
    private init() {
        homeTabBarController = HomeTabBarController()
        
        fileStorage = DiskFileStorage()
        documentCameraManager = VisionDocumentCameraManager(pdfMaker: VisionSearchablePDFMaker(),
                                                            fileStorage: fileStorage)
        positionKeeper = PDFDocumentPositionKeeper()
        pdfDocumentRouter = PDFDocumentRouter(fileStorage: fileStorage,
                                              positionKeeper: positionKeeper)
        
        homeTabBarController.viewControllers = [filesNavigationController(),
                                                scanningNavigationController(),
                                                accountNavigationController()]
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
        return navigationController(with: MyFilesRouter(fileStorage: fileStorage,
                                                        documentCameraManager: documentCameraManager,
                                                        pdfDocumentRouter: pdfDocumentRouter).make(),
                                    tabBarItem: filesTabBarItem())
    }
    
    func scanningNavigationController() -> UINavigationController {
        return navigationController(with: ScanningRouter(documentCameraManager: documentCameraManager,
                                                         pdfDocumentRouter: pdfDocumentRouter).make(),
                                    tabBarItem: scanningTabBarItem())
    }
    
    func accountNavigationController() -> UINavigationController {
        return navigationController(with: AccountRouter().make(),
                                    tabBarItem: accountTabBarItem())
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
    
    func accountTabBarItem() -> UITabBarItem {
        return tabBarItem(withTitle: String(localized: "accountTabBarItemTitle"),
                          image: UIImage(systemName: "person.crop.circle"))
    }
    
    func tabBarItem(withTitle title: String,
                    image: UIImage?,
                    selectedImage: UIImage? = nil) -> UITabBarItem {
        return UITabBarItem(title: title,
                            image: image,
                            selectedImage: selectedImage)
    }
}
