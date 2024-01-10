//
//  VisionDocumentCameraManager.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation
import VisionKit

class VisionDocumentCameraManager: DynamicUINotifier, DocumentCameraManagerProtocol {
    
    public var isDocumentCameraSupported: Bool {
        return VNDocumentCameraViewController.isSupported
    }
    
    func documentCameraRouter() -> RouterProtocol {
        return VisionDocumentCameraRouter(delegate: self)
    }
}
