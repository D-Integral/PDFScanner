//
//  DiskFileStorage.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation

final class DiskFileStorage: FileStorageProtocol {
    var userKeeper: UserKeeperProtocol
    
    init(userKeeper: UserKeeperProtocol) {
        self.userKeeper = userKeeper
        
        self.updateFilesList()
    }
    
    // MARK: FileStorageProtocol
    
    func updateFilesList() {
        if userKeeper.currentUser == nil {
            self.filesList = nil
        } else {
            do {
                self.filesList = try retrieveFilesList()
            } catch {
                print(error)
            }
            
            if nil == self.filesList {
                self.filesList = DiskFilesList(diskFiles: [UUID : DiskFile]())
            }
        }
    }
    
    var fileNames: [String] {
        return Array(arrayLiteral: filesList?.files.keys) as? [String] ?? []
    }
    
    var filesCount: Int {
        return filesList?.files.count ?? 0
    }
    
    func file(withId fileId: UUID) -> (any FileProtocol)? {
        return filesList?.files[fileId]
    }
    
    func save(_ file: any FileProtocol) throws {
        guard let diskFile = file as? DiskFile else {
            throw DiskFileStorageError.wrongFileType
        }
        
        filesList?.files[diskFile.id] = diskFile
        
        synchronize()
    }
    
    func delete(_ fileId: UUID) {
        filesList?.files.removeValue(forKey: fileId)
        
        synchronize()
    }
    
    func files() -> [any FileProtocol] {
        return Array(filesList?.files.values ?? [UUID: any FileProtocol]().values)
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
    
    func saveFilesList() throws {
        guard let url = filesListUrl else {
            throw DiskFileStorageError.filesListUrlIsBroken
        }
        
        let jsonData = try JSONEncoder().encode(filesList)
        try jsonData.write(to: url)
    }
    
    func retrieveFilesList() throws -> DiskFilesList? {
        guard let url = filesListUrl else {
            throw DiskFileStorageError.filesListUrlIsBroken
        }
        
        let jsonData = try Data(contentsOf: url)
        
        return try JSONDecoder().decode(DiskFilesList.self,
                                        from: jsonData)
    }
    
    // MARK: - Private Methods
    
    private var filesListUrl: URL? {
        guard let currentUserEmail = userKeeper.currentUser?.email else {
            return nil
        }
        
        let fileManager = FileManager.default
        let documentDirectoryURL = (fileManager.urls(for: .documentDirectory,
                                                     in: .userDomainMask)).last as? NSURL
        
        return documentDirectoryURL?.appendingPathComponent(currentUserEmail) as? URL
    }
}
