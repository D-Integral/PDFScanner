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
        self.updateUI()
        self.timeConsumingOperationStarted()
        
        var images = [UIImage]()
        
        for index in 0 ..< scan.pageCount {
            images.append(scan.imageOfPage(at: index))
        }
        
        pdfMaker.generatePdfDocumentFile(from: images) { [weak self] file, error in
            if let error = error {
                debugPrint(error)
                return
            }
            
            if let file = file as? DiskFile {
                self?.lastScannedFile = file
                
                do {
                    try self?.fileStorage.save(file)
                } catch {
                    debugPrint(error)
                }
            }
            
            self?.timeConsumingOperationCompleted()
            self?.updateUI()
        }
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        updateUI()
    }
}
