//
//  ApplicationState+FileManagerApplicationStateProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 18/01/2024.
//

import Foundation

extension ApplicationState: FileManagerApplicationStateProtocol {
    
    public var files: [any FileProtocol]? {
        return fileStorage.files()
    }
    
    func file(withId fileId: UUID) -> (any FileProtocol)? {
        return fileStorage.file(withId: fileId)
    }
    
    public func save(_ file: any FileProtocol) throws {
        try fileStorage.save(file)
    }
    
    public func delete(_ fileId: UUID) {
        fileStorage.delete(fileId)
    }
    
    public func opened(_ fileId: UUID) {
        fileStorage.opened(fileId)
    }
    
    public func rename(_ fileId: UUID,
                       to newName: String) {
        fileStorage.rename(fileId, to: newName)
    }
}
