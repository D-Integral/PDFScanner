//
//  VisionDocumentCameraRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation
import VisionKit

class VisionDocumentCameraRouter: RouterProtocol {
    
    // MARK: - Public Interface
    
    public init(delegate: VNDocumentCameraViewControllerDelegate) {
        self.delegate = delegate
    }
    
    public func make() -> UIViewController {
        let documentCameraViewController: VNDocumentCameraViewController = VNDocumentCameraViewController()
        
        documentCameraViewController.delegate = delegate
        
        return documentCameraViewController
    }
    
    // MARK: - Private Properties
    
    private let delegate: VNDocumentCameraViewControllerDelegate
}
