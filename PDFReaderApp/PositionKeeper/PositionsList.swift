//
//  PositionsList.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 09/01/2024.
//

import Foundation

struct PositionsList: PositionsListProtocol {
    
    var positions: [UUID: any PositionProtocol] {
        get {
            return savedPositions
        }
        set {
            savedPositions = newValue as? [UUID: Position] ?? [UUID: Position]()
        }
    }
    
    init(positions: [UUID : Position]) {
        self.savedPositions = positions
    }
    
    private var savedPositions: [UUID: Position]
}
