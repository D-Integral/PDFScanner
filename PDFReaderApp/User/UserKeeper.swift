//
//  UserKeeper.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 07/01/2024.
//

import Foundation

class UserKeeper: UserKeeperProtocol {
    var currentUser: UserProtocol? {
        return user
    }
    
    private var user: User?
    
    init() {
        do {
            try restoreCurrentUser()
        } catch {
            debugPrint(error)
        }
    }
    
    deinit {
        do {
            try saveCurrentUser()
        } catch {
            debugPrint(error)
        }
    }
    
    func restoreCurrentUser() throws {
        guard let url = currentUserUrl else {
            throw UserError.brokenUrl
        }
        
        let jsonData = try Data(contentsOf: url)
        
        user = try JSONDecoder().decode(User.self,
                                        from: jsonData)
    }
    
    func saveCurrentUser() throws {
        guard let url = currentUserUrl else {
            throw DiskFileStorageError.filesListUrlIsBroken
        }
        
        let jsonData = try JSONEncoder().encode(user)
        try jsonData.write(to: url)
    }
    
    func updateCurrentUser(withUser newUserOrNil: User?) {
        user = newUserOrNil
        
        do {
            try saveCurrentUser()
        } catch {
            debugPrint(error)
        }
    }
    
    func updateCurrentUserName(withName newName: String) {
        guard user?.name != newName else { return }
        
        user?.name = newName
        
        do {
            try saveCurrentUser()
        } catch {
            debugPrint(error)
        }
    }
    
    private var currentUserUrl: URL? {
        let fileManager = FileManager.default
        let documentDirectoryURL = (fileManager.urls(for: .documentDirectory,
                                                     in: .userDomainMask)).last as? NSURL
        
        return documentDirectoryURL?.appendingPathComponent("currentUser") as? URL
    }
}
