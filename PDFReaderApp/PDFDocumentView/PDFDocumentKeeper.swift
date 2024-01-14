//
//  PDFDocumentInteractor+PDFDocumentDelegate.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 08/01/2024.
//

import Foundation
import PDFKit

class PDFDocumentKeeper: DynamicUINotifier {
    let pdfDocument: PDFDocument?
    
    var searchResults: [PDFSelection] = []
    var searchResultsCount: Int = 0
    
    init(diskFile: DiskFile?) {
        if (.pdfDocument == diskFile?.fileType),
           let pdfDocumentData = diskFile?.documentData {
            self.pdfDocument = PDFDocument(data: pdfDocumentData)
        } else {
            self.pdfDocument = nil
        }
        
        super.init()
        
        self.pdfDocument?.delegate = self
    }
    
    // MARK: - Search
    
    func search(withQuery searchQuery: String) {
        if !searchQuery.isEmpty {
            timeConsumingOperationStarted()
        }
        
        pdfDocument?.cancelFindString()
        pdfDocument?.beginFindString(searchQuery,
                                     withOptions: .caseInsensitive)
    }
    
    func resetSearchResults() {
        searchResults = []
        searchResultsCount = 0
        
        updateUI()
    }
}
