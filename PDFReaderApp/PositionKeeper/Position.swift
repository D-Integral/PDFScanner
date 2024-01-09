//
//  Position.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 09/01/2024.
//

import Foundation

struct Position: PositionProtocol {
    var page: Int
    var point: CGPoint
    var zoom: CGFloat
}
