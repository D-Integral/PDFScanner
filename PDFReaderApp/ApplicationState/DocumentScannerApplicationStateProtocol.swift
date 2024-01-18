//
//  DocumentScannerApplicationStateProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 18/01/2024.
//

import Foundation

protocol DocumentScannerApplicationStateProtocol {
    var isDocumentCameraSupported: Bool { get }
    var lastScannedFile: (any FileProtocol)? { get }
    
    var documentCameraRouter: RouterProtocol { get }
}
