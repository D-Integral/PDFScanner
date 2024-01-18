//
//  ApplicationState.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 18/01/2024.
//

import Foundation

class ApplicationState: DynamicUINotifier {
    
    // MARK: - File Manager
    
    let fileStorage: FileStorageProtocol
    
    // MARK: - Document Viewer
    
    let positionKeeper: PositionKeeperProtocol
    
    // MARK: - Document Scanner
    
    let documentCameraManager: DocumentCameraManagerProtocol
    
    // MARK: - Initializers
    
    init(fileStorage: FileStorageProtocol,
         positionKeeper: PositionKeeperProtocol,
         documentCameraManager: DocumentCameraManagerProtocol) {
        self.fileStorage = fileStorage
        self.positionKeeper = positionKeeper
        self.documentCameraManager = documentCameraManager
        
        super.init()
    }
    
    // MARK: - DynamicUINotifier
    
    override func add(dynamicUI: DynamicUIProtocol) {
        super.add(dynamicUI: dynamicUI)
        
        self.documentCameraManager.add(dynamicUI: dynamicUI)
    }
    
    override func remove(dynamicUI: DynamicUIProtocol) {
        super.remove(dynamicUI: dynamicUI)
        
        self.documentCameraManager.remove(dynamicUI: dynamicUI)
    }
}
