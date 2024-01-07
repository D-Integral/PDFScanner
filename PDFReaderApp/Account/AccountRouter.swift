//
//  AccountRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import UIKit

class AccountRouter: RouterProtocol {
    func make(accountManager: AccountManagerProtocol,
              fileStorage: FileStorageProtocol) -> UIViewController {
        let interactor = AccountInteractor(accountManager: accountManager,
                                           fileStorage: fileStorage)
        let presenter = AccountPresenter(interactor: interactor)
                                         
        let signUpViewController = SignUpRouter().make(accountManager: accountManager)
        
        return AccountViewController(presenter: presenter,
                                     signUpViewController: signUpViewController)
    }
}
