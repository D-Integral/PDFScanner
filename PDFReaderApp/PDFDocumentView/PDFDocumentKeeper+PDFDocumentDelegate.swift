//
//  PDFDocumentKeeper+PDFDocumentDelegate.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 08/01/2024.
//

import Foundation
import PDFKit

extension PDFDocumentKeeper: PDFDocumentDelegate {
    func documentDidFindMatch(_ notification: Notification) {
        if let selection = notification.userInfo?.first?.value as? PDFSelection {
            selection.color = .systemYellow
            
            searchResults.append(selection)
        }
    }
    
    func documentDidEndDocumentFind(_ notification: Notification) {
        searchResults.sort { leftSelection, rightSelection in
            return leftSelection < rightSelection
        }
        
        searchResultsCount = searchResults.count
        
        timeConsumingOperationCompleted()
        updateUI()
    }
}
