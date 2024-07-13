//
//  DocumentCameraManagerProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation
import NefertitiFile

protocol DocumentCameraManagerProtocol: DynamicUINotifierProtocol {
    var isDocumentCameraSupported: Bool { get }
    
    var lastScannedFile: (any NefertitiFileProtocol)? { get set }
    
    func documentCameraRouter() -> RouterProtocol
}
