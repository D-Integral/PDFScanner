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
    private let fileStorage: FileStorageProtocol
    
    init(accountManager: AccountManagerProtocol,
         fileStorage: FileStorageProtocol) {
        self.accountManager = accountManager
        self.fileStorage = fileStorage
    }
    
    var userLogged: Bool {
        return accountManager.userLogged
    }
    
    var currentUser: User? {
        return accountManager.currentUser as? User
    }
    
    func startListen() {
        accountManager.startListen()
    }
    
    func stopListen() {
        accountManager.stopListen()
    }
    
    func logIn(withEmail email: String,
               password: String,
               completionHandler: @escaping (User?, Error?) -> ()) {
        accountManager.logIn(withEmail: email,
                             password: password) { [weak self] user, error in
            self?.fileStorage.updateFilesList()
            completionHandler(user, error)
        }
    }
    
    func signIn(withServiceProvider signInServiceProvider: SignInServiceProvider,
                completionHandler: @escaping (User?, Error?) -> ()) {
        
        accountManager.signIn(withServiceProvider: signInServiceProvider) { [weak self] user, error in
            self?.fileStorage.updateFilesList()
            completionHandler(user, error)
        }
    }
    
    func logOut(_ completionHandler: (Error?) -> ()) {
        accountManager.logOut { [weak self] error in
            self?.fileStorage.updateFilesList()
            completionHandler(error)
        }
    }
}
