//
//  PDFMakerScanResult.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 13/01/2024.
//

import Foundation

struct PDFMakerScanResult: PDFMakerScanResultProtocol {
    var data: Data
    var pageNumber: Int
}
