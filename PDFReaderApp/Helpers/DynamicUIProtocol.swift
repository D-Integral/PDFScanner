//
//  DynamicUIProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/01/2024.
//

import Foundation

@objc protocol DynamicUIProtocol {
    func updateDynamicUI()
    func timeConsumingOperationStarted()
    func timeConsumingOperationCompleted()
}
