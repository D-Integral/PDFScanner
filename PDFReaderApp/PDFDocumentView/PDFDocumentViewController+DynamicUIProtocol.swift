//
//  PDFDocumentViewController+DynamicUIProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 08/01/2024.
//

import Foundation
import PDFKit

extension PDFDocumentViewController {
    override func updateDynamicUI() {
        showHideSearchResults()
    }
    
    override func timeConsumingOperationStarted() {
        activityView.startAnimating()
    }
    
    override func timeConsumingOperationCompleted() {
        activityView.stopAnimating()
    }
}
