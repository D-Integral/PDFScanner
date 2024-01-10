//
//  ScanningViewController+DynamicUIProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation

extension ScanningViewController {
    override func updateDynamicUI() {
        if documentCameraViewController != nil {
            navigationController?.dismiss(animated: true)
            documentCameraViewController = nil
        }
    }
    
    override func timeConsumingOperationStarted() {
    }
    
    override func timeConsumingOperationCompleted() {
    }
}
