//
//  PositionsListProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 09/01/2024.
//

import Foundation

protocol PositionsListProtocol: Codable {
    var positions: [UUID: any PositionProtocol] { get set }
}
