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
        return applicationState.isDocumentCameraSupported
    }
    
    public var lastScannedFile: (any FileProtocol)? {
        return applicationState.lastScannedFile
    }
    
    // MARK: - Initializers
    
    public init(applicationState: (DocumentScannerApplicationStateProtocol & DynamicUINotifierProtocol)) {
        self.applicationState = applicationState
    }
    
    public func documentCameraRouter() -> RouterProtocol {
        return applicationState.documentCameraRouter
    }
    
    public func add(dynamicUI: DynamicUIProtocol) {
        applicationState.add(dynamicUI: dynamicUI)
    }
    
    public func remove(dynamicUI: DynamicUIProtocol) {
        applicationState.remove(dynamicUI: dynamicUI)
    }
    
    // MARK: - Private Properties
    
    private let applicationState: (DocumentScannerApplicationStateProtocol & DynamicUINotifierProtocol)
}
