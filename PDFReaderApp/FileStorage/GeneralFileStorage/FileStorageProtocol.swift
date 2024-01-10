//
//  FileStorageProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation

protocol FileStorageProtocol {
    var fileNames: [String] { get }
    var filesCount: Int { get }
    
    func updateFilesList()
    
    func file(withId fileId: UUID) -> (any FileProtocol)?
    func files() -> [any FileProtocol]
    
    func save(_ file: any FileProtocol) throws
    func delete(_ fileId: UUID)
}
