//
//  PDFDocumentRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 04/01/2024.
//

import Foundation
import UIKit

class PDFDocumentRouter: DocumentRouter {
    func make(diskFile: DiskFile,
              positionKeeper: PositionKeeperProtocol) -> UIViewController {
        let interactor = PDFDocumentInteractor(diskFile: diskFile,
                                               positionKeeper: positionKeeper)
        let presenter = PDFDocumentPresenter(interactor: interactor)
        let viewController = PDFDocumentViewController(presenter: presenter)
        
        return navigationController(with: viewController)
    }
}
