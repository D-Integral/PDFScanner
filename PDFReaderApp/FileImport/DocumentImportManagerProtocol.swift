//
//  DocumentImportManagerProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 31/12/2023.
//

import Foundation

protocol DocumentImportManagerProtocol {
    var fileStorage: FileStorageProtocol { get }
    var documentTypeTag: String? { get }
    
    init(fileStorage: FileStorageProtocol)
    
    func save(from url: URL,
              completionHandler: @escaping () -> ())
    func documentFile(from fileUrl: URL,
                      completionHandler: @escaping ((any FileProtocol)?,
                                                    DocumentImportError?) -> ())
    func importDocuments(at urls: [URL],
                         completionHandler: @escaping () -> ())

}
