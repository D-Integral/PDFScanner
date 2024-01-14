//
//  PDFDocumentExtensions.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 14/01/2024.
//

import Foundation
import PDFKit

extension PDFDocument {
    func generateThumbnailData(for thumbnailSize: CGSize) -> Data? {
        let pdfDocumentPage = page(at: 0)
        let thumbnail = pdfDocumentPage?.thumbnail(of: thumbnailSize,
                                                   for: PDFDisplayBox.trimBox)
        
        return thumbnail?.pngData()
    }
}
