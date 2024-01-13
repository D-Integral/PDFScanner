//
//  PDFMakerScanResultProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 13/01/2024.
//

import Foundation

protocol PDFMakerScanResultProtocol {
    var data: Data { get }
    var pageNumber: Int { get }
}
