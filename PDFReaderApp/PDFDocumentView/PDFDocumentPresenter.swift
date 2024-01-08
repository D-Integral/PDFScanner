//
//  PDFDocumentPresenter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 08/01/2024.
//

import Foundation
import PDFKit

class PDFDocumentPresenter: PresenterProtocol {
    var title: String {
        interactor?.documentName ?? ""
    }
    
    var pdfDocument: PDFDocument? {
        interactor?.pdfDocument
    }
    
    let interactor: PDFDocumentInteractor?
    
    var searchResults: [PDFSelection] {
        return interactor?.searchResults ?? []
    }
    
    init(interactor: PDFDocumentInteractor?) {
        self.interactor = interactor
    }
    
    func add(dynamicUI: any DynamicUIProtocol) {
        interactor?.add(dynamicUI: dynamicUI)
    }
    
    func remove(dynamicUI: any DynamicUIProtocol) {
        interactor?.remove(dynamicUI: dynamicUI)
    }
    
    func search(withQuery searchQuery: String?) {
        guard let searchQuery = searchQuery else {
            interactor?.resetSearchResults()
            return
        }
        
        interactor?.search(withQuery: searchQuery)
    }
    
    func resetSearchResults() {
        interactor?.resetSearchResults()
    }
}
