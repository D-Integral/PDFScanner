//
//  ScanningRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import UIKit

class ScanningRouter: RouterProtocol {
    
    // MARK: Public Interface
    
    public init(documentCameraManager: DocumentCameraManagerProtocol) {
        self.documentCameraManager = documentCameraManager
    }
    
    func make() -> UIViewController {
        let interactor = ScanningInteractor(documentCameraManager: documentCameraManager)
        let presenter = ScanningPresenter(interactor: interactor)
        
        return ScanningViewController(presenter: presenter)
    }
    
    // MARK: - Private Properties
    
    private let documentCameraManager: DocumentCameraManagerProtocol
}
