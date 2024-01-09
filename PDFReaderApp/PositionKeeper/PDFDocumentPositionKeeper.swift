//
//  PDFDocumentPositionKeeper.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 09/01/2024.
//

import Foundation

class PDFDocumentPositionKeeper: PositionKeeperProtocol {
    
    // MARK: - Properties
    
    private var positionsList: PositionsList? = nil
    
    private let positionsFileName = "positions"
    
    // MARK: - Life Cycle
    
    init() {
        retrieveOrCreatePositionsList()
    }
    
    // MARK: - PositionKeeperProtocol
    
    func save(position: PositionProtocol, for fileId: UUID) {
        positionsList?.positions[fileId] = position
        
        synchronize()
    }
    
    func position(for fileId: UUID?) -> PositionProtocol? {
        guard let fileId = fileId else { return nil }
        
        return positionsList?.positions[fileId]
    }
    
    // MARK: - Private Methods
    
    private func synchronize() {
        do {
            try savePositionsList()
        } catch {
            print(error)
        }
    }
    
    private func savePositionsList() throws {
        guard let url = positionsListUrl else {
            throw PositionKeeperError.positionsListUrlIsBroken
        }
        
        let jsonData = try JSONEncoder().encode(positionsList)
        try jsonData.write(to: url)
    }
    
    private func retrieveOrCreatePositionsList() {
        do {
            self.positionsList = try retrievePositionsList()
        } catch {
            print(error)
        }
        
        if nil == self.positionsList {
            self.positionsList = PositionsList(positions: [UUID : Position]())
        }
    }
    
    private func retrievePositionsList() throws -> PositionsList? {
        guard let url = positionsListUrl else {
            throw PositionKeeperError.positionsListUrlIsBroken
        }
        
        let jsonData = try Data(contentsOf: url)
        
        return try JSONDecoder().decode(PositionsList.self,
                                        from: jsonData)
    }
    
    private var positionsListUrl: URL? {
        let fileManager = FileManager.default
        let documentDirectoryURL = (fileManager.urls(for: .documentDirectory,
                                                     in: .userDomainMask)).last as? NSURL
        
        return documentDirectoryURL?.appendingPathComponent(positionsFileName) as? URL
    }
}
