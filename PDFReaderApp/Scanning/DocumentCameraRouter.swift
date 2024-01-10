//
//  DocumentCameraRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation
import VisionKit

class DocumentCameraRouter: FullScreenRouter {
    
    func make(withDelegate dlegate: VNDocumentCameraViewControllerDelegate) -> UINavigationController {
        let documentCameraViewController: VNDocumentCameraViewController = VNDocumentCameraViewController()
        
        documentCameraViewController.delegate = dlegate
        
        return fullScreenNavigationController(with: documentCameraViewController)
    }
}
