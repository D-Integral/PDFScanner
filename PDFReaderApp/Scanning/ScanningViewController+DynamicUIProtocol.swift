//
//  ScanningViewController+DynamicUIProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation

extension ScanningViewController {
    override func updateDynamicUI() {
        hideDocumentCamera()
        showJustScannedFileIfExists()
    }
    
    override func timeConsumingOperationStarted() {
        activityView.startAnimating()
    }
    
    override func timeConsumingOperationCompleted() {
        activityView.stopAnimating()
    }
}
