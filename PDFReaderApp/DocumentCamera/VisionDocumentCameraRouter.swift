//
//  VisionDocumentCameraRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation
import VisionKit

class VisionDocumentCameraRouter: FullScreenRouter {
    
    // MARK: - Public Interface
    
    public init(delegate: VNDocumentCameraViewControllerDelegate) {
        self.delegate = delegate
    }
    
    override public func make() -> UINavigationController {
        let documentCameraViewController: VNDocumentCameraViewController = VNDocumentCameraViewController()
        
        documentCameraViewController.delegate = delegate
        
        return fullScreenNavigationController(with: documentCameraViewController)
    }
    
    // MARK: - Private Properties
    
    private let delegate: VNDocumentCameraViewControllerDelegate
}
