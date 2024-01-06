//
//  MyFilesViewController+DynamicUIProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation

extension MyFilesViewController {
    override func updateDynamicUI() {
        applySnapshot()
    }
    
    override func timeConsumingOperationStarted() {
        activityView.startAnimating()
    }
    
    override func timeConsumingOperationCompleted() {
        activityView.stopAnimating()
    }
}
