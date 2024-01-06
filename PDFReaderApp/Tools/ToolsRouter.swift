//
//  ToolsRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import UIKit

class ToolsRouter: RouterProtocol {
    func make() -> UIViewController {
        let interactor = ToolsInteractor()
        let presenter = ToolsPresenter(interactor: interactor)
        
        return ToolsViewController(presenter: presenter)
    }
}
