//
//  AccountManagementError.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 07/01/2024.
//

import Foundation

enum AccountManagementError: Error {
    case noUserRetrievedFromServer
    case noUserIdTokenRetrievedFromServer
    case noCredentialRetrievedFromServer
    case noAuthResultRetrievedFromServer
}
