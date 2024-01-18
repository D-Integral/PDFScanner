//
//  ApplicationState+DocumentViewerApplicationStateProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 18/01/2024.
//

import Foundation

extension ApplicationState: DocumentViewerApplicationStateProtocol {
    public func save(position: PositionProtocol,
                     for fileId: UUID) {
        positionKeeper.save(position: position,
                            for: fileId)
    }
    
    public func position(for fileId: UUID?) -> PositionProtocol? {
        positionKeeper.position(for: fileId)
    }
}
