//
//  DocumentScannerApplicationStateProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 18/01/2024.
//

import Foundation
import NefertitiFile

protocol DocumentScannerApplicationStateProtocol {
    var isDocumentCameraSupported: Bool { get }
    var lastScannedFile: (any NefertitiFileProtocol)? { get }
    
    var documentCameraRouter: RouterProtocol { get }
}
