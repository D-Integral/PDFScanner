//
//  DiskFilesList.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation
import NefertitiFile

struct DiskFilesList: FilesListProtocol {
    init(diskFiles: [UUID : NefertitiFile]) {
        self.diskFiles = diskFiles
    }
    
    var files: [UUID: any NefertitiFileProtocol] {
        get {
            return diskFiles
        }
        set {
            diskFiles = newValue as? [UUID: NefertitiFile] ?? [UUID: NefertitiFile]()
        }
    }
    
    private var diskFiles: [UUID: NefertitiFile]
}
