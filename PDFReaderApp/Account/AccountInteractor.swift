//
//  AccountInteractor.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

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
               completionHandler: @escaping (User, Error?) -> ()) {
        accountManager.logIn(withEmail: email,
                             password: password) { user, error in
            completionHandler(user, error)
        }
    }
    
    func logIn(withCredential credential: AuthCredential,
               completionHandler: @escaping (User, Error?) -> ()) {
        accountManager.logIn(withCredential: credential) { user, error in
            completionHandler(user, error)
        }
    }
    
    func logOut(_ completionHandler: (Error?) -> ()) {
        accountManager.logOut { error in
            completionHandler(error)
        }
    }
}
