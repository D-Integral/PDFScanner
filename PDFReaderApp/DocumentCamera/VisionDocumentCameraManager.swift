//
//  VisionDocumentCameraManager.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation
import VisionKit

class VisionDocumentCameraManager: DynamicUINotifier, DocumentCameraManagerProtocol {
    
    let pdfMaker: PDFMakerProtocol
    let fileStorage: FileStorageProtocol
    
    var lastScannedFile: (any FileProtocol)? = nil
    
    init(pdfMaker: PDFMakerProtocol,
         fileStorage: FileStorageProtocol) {
        self.pdfMaker = pdfMaker
        self.fileStorage = fileStorage
    }
    
    public var isDocumentCameraSupported: Bool {
        return VNDocumentCameraViewController.isSupported
    }
    
    func documentCameraRouter() -> RouterProtocol {
        return VisionDocumentCameraRouter(delegate: self)
    }
}
