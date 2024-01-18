//
//  DocumentViewerApplicationStateProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 18/01/2024.
//

import Foundation

protocol DocumentViewerApplicationStateProtocol {
    func save(position: PositionProtocol,
              for fileId: UUID)
    func position(for fileId: UUID?) -> PositionProtocol?
}
