//
//  DocumentCameraManagerProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation

protocol DocumentCameraManagerProtocol: DynamicUINotifierProtocol {
    var isDocumentCameraSupported: Bool { get }
    
    var lastScannedFile: (any FileProtocol)? { get set }
    
    func documentCameraRouter() -> RouterProtocol
}
