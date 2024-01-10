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
    
    let userKeeper: UserKeeperProtocol
    let fileStorage: FileStorageProtocol
    let accountManager: AccountManagerProtocol
    
    private init() {
        homeTabBarController = HomeTabBarController()
        
        userKeeper = UserKeeper()
        fileStorage = DiskFileStorage(userKeeper: userKeeper)
        accountManager = FirebaseAccountManager(userKeeper: userKeeper)
        
        homeTabBarController.viewControllers = [filesNavigationController(),
                                                toolsNavigationController(),
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
        return navigationController(with: MyFilesRouter().make(fileStorage: fileStorage,
                                                               accountManager: accountManager),
                                    tabBarItem: filesTabBarItem())
    }
    
    func toolsNavigationController() -> UINavigationController {
        return navigationController(with: ScanRouter().make(),
                                    tabBarItem: toolsTabBarItem())
    }
    
    func accountNavigationController() -> UINavigationController {
        return navigationController(with: AccountRouter().make(accountManager: accountManager,
                                                               fileStorage: fileStorage),
                                    tabBarItem: accountTabBarItem())
    }
    
    // MARK: Tab bar items
    
    func filesTabBarItem() -> UITabBarItem {
        return tabBarItem(withTitle: String(localized: "filesTabBarItemTitle"),
                          image: UIImage(systemName: "folder"))
    }
    
    func toolsTabBarItem() -> UITabBarItem {
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
