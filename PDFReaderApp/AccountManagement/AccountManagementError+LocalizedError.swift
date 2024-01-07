//
//  AccountManagementError+LocalizedError.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 07/01/2024.
//

import Foundation

extension AccountManagementError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noUserRetrievedFromServer:
            return String(localized: "The attempt to sign in has been unsuccessful: no user retrieved from the sign in provider server.")
        case .noUserIdTokenRetrievedFromServer:
            return String(localized: "The attempt to sign in has been unsuccessful: no id token retrieved from the sign in provider server.")
        case .noCredentialRetrievedFromServer:
            return String(localized: "No sign in credential retrieved from the sign in provider server.")
        case .noAuthResultRetrievedFromServer:
            return String(localized: "No auth result retrieved from the sign in provider server.")
        }
    }
}
