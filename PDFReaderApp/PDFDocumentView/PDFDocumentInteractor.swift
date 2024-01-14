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
    private let positionKeeper: PositionKeeperProtocol?
    private let diskFile: DiskFile?
    private let fileStorage: FileStorageProtocol?
    
    var pdfDocument: PDFDocument? {
        return pdfDocumentKeeper?.pdfDocument
    }
    
    var searchResults: [PDFSelection]? {
        return pdfDocumentKeeper?.searchResults
    }
    
    var searchResultsCount: Int? {
        return pdfDocumentKeeper?.searchResultsCount
    }
    
    var documentName: String {
        return diskFile?.title ?? ""
    }
    
    private(set) var currentSearchResultIndex = 0
    
    var currentSearchResult: PDFSelection? {
        return searchResults?[currentSearchResultIndex - 1]
    }
    
    var savedPosition: PositionProtocol? {
        return positionKeeper?.position(for: diskFile?.id)
    }
    
    init(diskFile: DiskFile?,
         positionKeeper: PositionKeeperProtocol?,
         fileStorage: FileStorageProtocol?) {
        self.pdfDocumentKeeper = PDFDocumentKeeper(diskFile: diskFile)
        self.diskFile = diskFile
        self.positionKeeper = positionKeeper
        self.fileStorage = fileStorage
    }
    
    public func rename(to newName: String) {
        guard let id = diskFile?.id else { return }
        
        fileStorage?.rename(id, to: newName)
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
        
        if (currentSearchResultIndex > searchResultsCount) {
            currentSearchResultIndex = 1
        }
    }
    
    func decrementCurrentSearchResultIndex() {
        currentSearchResultIndex -= 1
        
        if (currentSearchResultIndex < 1) {
            let searchResultsCount = searchResultsCount ?? 0
            currentSearchResultIndex = searchResultsCount
        }
    }
    
    func save(position: PositionProtocol) {
        guard let fileId = diskFile?.id else { return }
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.positionKeeper?.save(position: position,
                                       for: fileId)
        }
    }
}
