//
//  FileManagerApplicationStateProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 18/01/2024.
//

import Foundation
import NefertitiFile

protocol FileManagerApplicationStateProtocol {
    var files: [any NefertitiFileProtocol]? { get }
    
    func file(withId fileId: UUID) -> (any NefertitiFileProtocol)?
    func save(_ file: any NefertitiFileProtocol) throws
    func delete(_ fileId: UUID)
    func opened(_ fileId: UUID)
    func rename(_ fileId: UUID,
                to newName: String)
}
