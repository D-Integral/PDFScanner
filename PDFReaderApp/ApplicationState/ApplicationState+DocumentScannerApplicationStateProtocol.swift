//
//  ApplicationState+DocumentScannerApplicationStateProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 18/01/2024.
//

import Foundation
import NefertitiFile

extension ApplicationState: DocumentScannerApplicationStateProtocol {
    public var isDocumentCameraSupported: Bool {
        return documentCameraManager.isDocumentCameraSupported
    }
    
    var lastScannedFile: (any NefertitiFileProtocol)? {
        get {
            return documentCameraManager.lastScannedFile
        }
        set {
            documentCameraManager.lastScannedFile = newValue
        }
    }
    
    public var documentCameraRouter: RouterProtocol {
        return documentCameraManager.documentCameraRouter()
    }
    
}
