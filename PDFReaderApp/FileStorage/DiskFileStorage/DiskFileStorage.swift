//
//  DiskFileStorage.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation
import NefertitiFile

final class DiskFileStorage: FileStorageProtocol {
    
    public init() {
        self.updateFilesList()
    }
    
    // MARK: FileStorageProtocol
    
    public func updateFilesList() {
        do {
            self.filesList = try retrieveFilesList()
        } catch {
            print(error)
        }
        
        if nil == self.filesList {
            self.filesList = DiskFilesList(diskFiles: [UUID : NefertitiFile]())
        }
    }
    
    public var fileNames: [String] {
        return Array(arrayLiteral: filesList?.files.keys) as? [String] ?? []
    }
    
    public var filesCount: Int {
        return filesList?.files.count ?? 0
    }
    
    public func file(withId fileId: UUID) -> (any NefertitiFileProtocol)? {
        return filesList?.files[fileId]
    }
    
    public func save(_ file: any NefertitiFileProtocol) throws {
        guard let diskFile = file as? NefertitiFile else {
            throw DiskFileStorageError.wrongFileType
        }
        
        filesList?.files[diskFile.id] = diskFile
        
        synchronize()
    }
    
    public func delete(_ fileId: UUID) {
        guard let diskFile = file(withId: fileId) as? NefertitiFile else { return }
        diskFile.clearData()
        
        filesList?.files.removeValue(forKey: fileId)
        
        synchronize()
    }
    
    public func opened(_ fileId: UUID) {
        guard var diskFile = file(withId: fileId) as? NefertitiFile else { return }
        
        diskFile.openedDate = Date()
        filesList?.files[fileId] = diskFile
        
        synchronize()
    }
    
    public func rename(_ fileId: UUID,
                       to newName: String) {
        guard !newName.isEmpty,
              var diskFile = file(withId: fileId) as? NefertitiFile else { return }
        
        diskFile.rename(to: newName)
        filesList?.files[fileId] = diskFile
        
        synchronize()
    }
    
    public func files() -> [any NefertitiFileProtocol] {
        return Array(filesList?.files.values ?? [UUID: any NefertitiFileProtocol]().values)
    }
    
    // MARK: Files List
    
    private var filesList: DiskFilesList? = nil
    
    func synchronize() {
        do {
            try saveFilesList()
        } catch {
            print(error)
        }
    }
    
    private func saveFilesList() throws {
        guard let url = filesListUrl else {
            throw DiskFileStorageError.filesListUrlIsBroken
        }
        
        let jsonData = try JSONEncoder().encode(filesList)
        try jsonData.write(to: url)
    }
    
    private func retrieveFilesList() throws -> DiskFilesList? {
        guard let url = filesListUrl else {
            throw DiskFileStorageError.filesListUrlIsBroken
        }
        
        let jsonData = try Data(contentsOf: url)
        
        return try JSONDecoder().decode(DiskFilesList.self,
                                        from: jsonData)
    }
    
    // MARK: - Private Methods
    
    private var filesListUrl: URL? {
        let fileManager = FileManager.default
        let documentDirectoryURL = (fileManager.urls(for: .documentDirectory,
                                                     in: .userDomainMask)).last as? NSURL
        
        return documentDirectoryURL?.appendingPathComponent("filesList") as? URL
    }
}
