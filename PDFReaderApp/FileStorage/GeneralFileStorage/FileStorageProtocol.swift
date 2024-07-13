//
//  FileStorageProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation
import NefertitiFile

protocol FileStorageProtocol {
    var fileNames: [String] { get }
    var filesCount: Int { get }
    
    func updateFilesList()
    
    func file(withId fileId: UUID) -> (any NefertitiFileProtocol)?
    func files() -> [any NefertitiFileProtocol]
    
    func save(_ file: any NefertitiFileProtocol) throws
    func delete(_ fileId: UUID)
    func opened(_ fileId: UUID)
    func rename(_ fileId: UUID,
                to newName: String)
}
