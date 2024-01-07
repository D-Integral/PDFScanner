//
//  FileProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation

protocol FileProtocol: Codable, Hashable {
    var id: UUID { get }
    var name: String { get set }
    var data: Data { get set }
    var createdDate: Date { get set }
    var modifiedDate: Date { get set }
    var fileType: FileType { get set }
    
    func info() -> String?
}
