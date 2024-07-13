//
//  DocumentImportManager.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 31/12/2023.
//

import Foundation
import NefertitiFile

class DocumentImportManager: NSObject, DocumentImportManagerProtocol {
    
    // MARK: DocumentImportManagerProtocol
    
    let applicationState: FileManagerApplicationStateProtocol
    
    var documentTypeTag: String? {
        return nil
    }
    
    required init(applicationState: FileManagerApplicationStateProtocol) {
        self.applicationState = applicationState
    }
    
    func save(from url: URL,
              thumbnailSize: CGSize,
              completionHandler: @escaping () -> ()) {
        documentFile(from: url,
                     thumbnailSize: thumbnailSize) { [weak self] file, error in
            if let error = error {
                print(error)
            }
            
            guard let file = file else {
                completionHandler()
                return
            }
            
            self?.save(file)
            completionHandler()
        }
    }
    
    func documentFile(from fileUrl: URL,
                      thumbnailSize: CGSize,
                      completionHandler: @escaping ((any NefertitiFileProtocol)?,
                                                    DocumentImportError?) -> ()) {
        completionHandler(nil,
                          nil)
    }
    
    func importDocuments(at urls: [URL],
                         thumbnailSize: CGSize,
                         completionHandler: @escaping () -> ()) { }
    
    // MARK: Private Methods
    
    private func save(_ file: any NefertitiFileProtocol) {
        do {
            try applicationState.save(file)
        } catch {
            print("An attempt to save the file \"\(file.title)\" to the storage has failed with the following error: \(error.localizedDescription)")
            return
        }
    }
}
