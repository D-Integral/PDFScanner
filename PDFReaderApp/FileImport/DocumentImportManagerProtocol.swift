//
//  DocumentImportManagerProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 31/12/2023.
//

import Foundation
import NefertitiFile

protocol DocumentImportManagerProtocol {
    var documentTypeTag: String? { get }
    
    init(applicationState: FileManagerApplicationStateProtocol)
    
    func save(from url: URL,
              thumbnailSize: CGSize,
              completionHandler: @escaping () -> ())
    func documentFile(from fileUrl: URL,
                      thumbnailSize: CGSize,
                      completionHandler: @escaping ((any NefertitiFileProtocol)?,
                                                    DocumentImportError?) -> ())
    func importDocuments(at urls: [URL],
                         thumbnailSize: CGSize,
                         completionHandler: @escaping () -> ())

}
