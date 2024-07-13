//
//  FilesListProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 29/12/2023.
//

import Foundation
import NefertitiFile

protocol FilesListProtocol: Codable {
    var files: [UUID: any NefertitiFileProtocol] { get set }
}
