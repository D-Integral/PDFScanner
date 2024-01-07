//
//  UserKeeperProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 07/01/2024.
//

import Foundation

protocol UserKeeperProtocol {
    var currentUser: UserProtocol? { get }
    
    func restoreCurrentUser() throws
    func saveCurrentUser() throws
    func updateCurrentUser(withUser newUserOrNil: User?)
    func updateCurrentUserName(withName newName: String)
}
