//
//  SignUpRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import UIKit

class SignUpRouter: RouterProtocol {
    func make(accountManager: AccountManagerProtocol) -> UIViewController {
        let interactor = SignUpInteractor(accountManager: accountManager)
        let presenter = SignUpPresenter(interactor: interactor)
        let sighUpViewController = SignUpViewController(presenter: presenter)
        
        return UINavigationController(rootViewController: sighUpViewController)
    }
}
