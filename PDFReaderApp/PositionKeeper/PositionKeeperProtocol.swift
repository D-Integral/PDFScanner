//
//  PositionKeeperProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 09/01/2024.
//

import Foundation

protocol PositionKeeperProtocol {
    func save(position: PositionProtocol,
              for fileId: UUID)
    func position(for fileId: UUID?) -> PositionProtocol?
}
