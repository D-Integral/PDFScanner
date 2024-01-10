//
//  DynamicUINotifierProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import Foundation

protocol DynamicUINotifierProtocol {
    func add(dynamicUI: any DynamicUIProtocol)
    func remove(dynamicUI: any DynamicUIProtocol)
}
