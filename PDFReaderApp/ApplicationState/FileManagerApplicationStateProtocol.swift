//
//  FileManagerApplicationStateProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 18/01/2024.
//

import Foundation

protocol FileManagerApplicationStateProtocol {
    var files: [any FileProtocol]? { get }
    
    func save(_ file: any FileProtocol) throws
    func delete(_ fileId: UUID)
    func opened(_ fileId: UUID)
    func rename(_ fileId: UUID,
                to newName: String)
}
