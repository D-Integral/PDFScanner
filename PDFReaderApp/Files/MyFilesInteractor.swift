//
//  MyFilesInteractor.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 30/12/2023.
//

import Foundation

class MyFilesInteractor: InteractorProtocol {
    
    // MARK: - Properties
    
    var files: [any FileProtocol]? {
        return fileStorage.files()
    }
    
    let documentPickerManager: DocumentPickerManager
    
    private let fileStorage: FileStorageProtocol
    private let documentCameraManager: DocumentCameraManagerProtocol?
    
    // MARK: - Life Cycle
    
    init(fileStorage: FileStorageProtocol,
         documentImportManager: DocumentImportManagerProtocol,
         documentCameraManager: DocumentCameraManagerProtocol? = nil) {
        self.fileStorage = fileStorage
        self.documentPickerManager = DocumentPickerManager(documentImportManager: documentImportManager)
        self.documentCameraManager = documentCameraManager
    }
    
    // MARK: - File Management
    
    func deleteFile(withId fileId: UUID) {
        fileStorage.delete(fileId)
    }
    
    func sortedAndFilteredFiles(for queryOrNil: String?) -> [any FileProtocol] {
        return filteredFiles(for: queryOrNil).sorted { fileA, fileB in
            return fileA.modifiedDate > fileB.modifiedDate
        }
    }
    
    // MARK: - Dynamic UI
    
    func add(dynamicUI: any DynamicUIProtocol) {
        documentCameraManager?.add(dynamicUI: dynamicUI)
    }
    
    func remove(dynamicUI: any DynamicUIProtocol) {
        documentCameraManager?.remove(dynamicUI: dynamicUI)
    }
    
    // MARK: - Private Functions
    
    private func filteredFiles(for queryOrNil: String?) -> [any FileProtocol] {
        guard let files = files else {
            return []
        }
        
        guard let query = queryOrNil,
              !query.isEmpty else {
            return files
        }
        
        return files.filter {
            return $0.name.lowercased().contains(query.lowercased())
        }
    }
}
