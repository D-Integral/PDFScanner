//
//  AccountRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import UIKit

class AccountRouter: RouterProtocol {
    func make() -> UIViewController {
        let interactor = AccountInteractor()
        let presenter = AccountPresenter(interactor: interactor)
        
        return AccountViewController(presenter: presenter)
    }
}
