//
//  AccountInteractor.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation

class AccountInteractor: InteractorProtocol {
    private let accountManager: AccountManagerProtocol
    
    init(accountManager: AccountManagerProtocol) {
        self.accountManager = accountManager
    }
    
    var userLogged: Bool {
        return accountManager.userLogged
    }
    
    func startListen() {
        accountManager.startListen()
    }
    
    func stopListen() {
        accountManager.stopListen()
    }
    
    func logIn(withEmail email: String,
               password: String,
               completionHandler: @escaping (Error?,
                                             User) -> ()) {
        accountManager.logIn(withEmail: email,
                             password: password) { error, user in
            completionHandler(error,
                              user)
        }
    }
    
    func logOut(_ completionHandler: (Error?) -> ()) {
        accountManager.logOut { error in
            completionHandler(error)
        }
    }
}
