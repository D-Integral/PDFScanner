//
//  PositionProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 09/01/2024.
//

import Foundation

protocol PositionProtocol: Codable {
    var page: Int { get set }
    var point: CGPoint { get set }
    var zoom: CGFloat { get set }
}
