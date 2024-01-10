//
//  ScanningInteractor.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation

class ScanningInteractor: InteractorProtocol {
    
    // MARK: - Public Interface
    
    public var isDocumentCameraSupported: Bool {
        return documentCameraManager.isDocumentCameraSupported
    }
    
    public init(documentCameraManager: DocumentCameraManagerProtocol) {
        self.documentCameraManager = documentCameraManager
    }
    
    public func documentCameraRouter() -> RouterProtocol {
        return documentCameraManager.documentCameraRouter()
    }
    
    public func add(dynamicUI: DynamicUIProtocol) {
        documentCameraManager.add(dynamicUI: dynamicUI)
    }
    
    public func remove(dynamicUI: DynamicUIProtocol) {
        documentCameraManager.remove(dynamicUI: dynamicUI)
    }
    
    // MARK: - Private Properties
    
    private let documentCameraManager: DocumentCameraManagerProtocol
}
