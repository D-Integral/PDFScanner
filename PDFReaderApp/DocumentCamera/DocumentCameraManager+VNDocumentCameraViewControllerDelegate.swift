//
//  DocumentCameraManager+VNDocumentCameraViewControllerDelegate.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation
import VisionKit

extension VisionDocumentCameraManager: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController,
                                      didFinishWith scan: VNDocumentCameraScan) {
        for index in 0 ..< scan.pageCount {
            let image = scan.imageOfPage(at: index)
        }
        
        updateUI()
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        updateUI()
    }
}
