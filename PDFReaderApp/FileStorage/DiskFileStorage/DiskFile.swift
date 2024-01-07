//
//  DiskFile.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation

struct DiskFile: FileProtocol {
    var id = UUID()
    var name: String
    var data: Data
    var createdDate: Date
    var modifiedDate: Date
    var fileType: FileType
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: DiskFile, rhs: DiskFile) -> Bool {
      lhs.id == rhs.id
    }
    
    func info() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let modifiedDateString = dateFormatter.string(from: modifiedDate)
        
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.countStyle = .file
        let dataSizeString = byteCountFormatter.string(fromByteCount: Int64(data.count))
        
        return "\(modifiedDateString) • \(dataSizeString)"
    }
}
