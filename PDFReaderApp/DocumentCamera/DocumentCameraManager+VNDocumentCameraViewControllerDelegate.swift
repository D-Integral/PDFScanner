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
        var images = [UIImage]()
        
        for index in 0 ..< scan.pageCount {
            let currentImage = scan.imageOfPage(at: index)
        }
        
        pdfMaker.generatePdfDocumentFile(from: images) { [weak self] file, error in
            if let error = error {
                debugPrint(error)
                return
            }
            
            self?.lastScannedFile = file
            self?.updateUI()
        }
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        updateUI()
    }
}
