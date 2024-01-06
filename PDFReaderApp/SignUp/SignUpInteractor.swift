//
//  SignUpInteractor.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation

class SignUpInteractor: InteractorProtocol {
    let accountManager: AccountManagerProtocol
    
    init(accountManager: AccountManagerProtocol) {
        self.accountManager = accountManager
    }
    
    func signUp(withEmail email: String,
                password: String,
                completionHandler: @escaping (Error?,
                                              User) -> ()) {
        accountManager.signUp(withEmail: email,
                              password: password) { error, user in
            completionHandler(error,
                              user)
        }
    }
}
