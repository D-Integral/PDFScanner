//
//  PDFDocumentInteractor.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 08/01/2024.
//

import Foundation
import PDFKit

class PDFDocumentInteractor: InteractorProtocol {
    private let pdfDocumentKeeper: PDFDocumentKeeper?
    var documentName: String
    
    var pdfDocument: PDFDocument? {
        return pdfDocumentKeeper?.pdfDocument
    }
    
    var searchResults: [PDFSelection]? {
        return pdfDocumentKeeper?.searchResults
    }
    
    var searchResultsCount: Int? {
        return pdfDocumentKeeper?.searchResultsCount
    }
    
    private(set) var currentSearchResultIndex = 0
    
    var currentSearchResult: PDFSelection? {
        return searchResults?[currentSearchResultIndex - 1]
    }
    
    init(diskFile: DiskFile?) {
        self.documentName = diskFile?.name ?? ""
        self.pdfDocumentKeeper = PDFDocumentKeeper(diskFile: diskFile)
    }
    
    func add(dynamicUI: any DynamicUIProtocol) {
        pdfDocumentKeeper?.add(dynamicUI: dynamicUI)
    }
    
    func remove(dynamicUI: any DynamicUIProtocol) {
        pdfDocumentKeeper?.remove(dynamicUI: dynamicUI)
    }
    
    func search(withQuery searchQuery: String) {
        pdfDocumentKeeper?.search(withQuery: searchQuery)
    }
    
    func resetSearchResults() {
        pdfDocumentKeeper?.resetSearchResults()
    }
    
    func incrementCurrentSearchResultIndex() {
        currentSearchResultIndex += 1
        
        let searchResultsCount = searchResultsCount ?? 0
        
        if (currentSearchResultIndex >= searchResultsCount) {
            currentSearchResultIndex = 1
        }
    }
    
    func decrementCurrentSearchResultIndex() {
        currentSearchResultIndex -= 1
        
        if (currentSearchResultIndex < 1) {
            let searchResultsCount = searchResultsCount ?? 0
            currentSearchResultIndex = searchResultsCount - 1
        }
    }
}
