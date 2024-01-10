//
//  DocumentRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 08/01/2024.
//

import Foundation
import UIKit

class FullScreenRouter: RouterProtocol {
    func fullScreenNavigationController(with viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .fullScreen
        nav.isModalInPresentation = false
        nav.modalTransitionStyle = .crossDissolve
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        nav.navigationBar.isTranslucent = false
        
        return nav
    }
}
