//
//  PDFDocumentRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 04/01/2024.
//

import Foundation
import UIKit

class PDFDocumentRouter: FullScreenRouter {
    public var diskFile: DiskFile? = nil
    
    init(fileStorage: FileStorageProtocol,
         positionKeeper: PositionKeeperProtocol) {
        self.fileStorage = fileStorage
        self.positionKeeper = positionKeeper
        
        super.init()
    }
    
    override func make() -> UIViewController {
        let interactor = PDFDocumentInteractor(diskFile: diskFile,
                                               positionKeeper: positionKeeper,
                                               fileStorage: fileStorage)
        let presenter = PDFDocumentPresenter(interactor: interactor)
        let viewController = PDFDocumentViewController(presenter: presenter)
        
        return fullScreenNavigationController(with: viewController)
    }
    
    private let fileStorage: FileStorageProtocol
    private let positionKeeper: PositionKeeperProtocol
}
