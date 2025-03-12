//
//  VisionDocumentCameraManager.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation
import VisionKit
import Nefertiti
import NefertitiFile

class VisionDocumentCameraManager: DynamicUINotifier, DocumentCameraManagerProtocol {
    let pdfMaker: NefertitiPDFMakerProtocol
    let fileStorage: FileStorageProtocol
    
    var lastScannedFile: (any NefertitiFileProtocol)? = nil
    
    init(pdfMaker: NefertitiPDFMakerProtocol,
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
