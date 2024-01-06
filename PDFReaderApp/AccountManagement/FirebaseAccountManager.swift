//
//  FirebaseAccountManager.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import FirebaseAuth

class FirebaseAccountManager: AccountManagerProtocol {
    var userLogged: Bool {
        return (nil != user)
    }
    
    var user: UserProtocol? = nil
    
    var authHandle: AuthStateDidChangeListenerHandle? = nil
    
    func startListen() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let updatedUserName = user?.displayName,
               updatedUserName != self?.user?.name {
                self?.user?.name = updatedUserName
            }
            
            if let updatedUserEmail = user?.email,
               updatedUserEmail != self?.user?.email {
                self?.user?.email = updatedUserEmail
            }
        }
    }
    
    func stopListen() {
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    func logIn(withEmail email: String,
               password: String,
               completionHandler: @escaping (Error?,
                                             User) -> ()) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { [weak self] authResult, error in
            let user = User(name: authResult?.user.displayName ?? "",
                            email: authResult?.user.email ?? "")
            
            self?.user = user
            
            completionHandler(error,
                              user)
        }
    }
    
    func signUp(withEmail email: String,
                password: String,
                completionHandler: @escaping (Error?,
                                              User) -> ()) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { authResult, error in
            let user = User(name: authResult?.user.displayName ?? "",
                            email: authResult?.user.email ?? "")
            
            completionHandler(error,
                              user)
        }
    }
    
    func logOut(_ completionHandler: (Error?) -> ()) {
        do {
            try Auth.auth().signOut()
        } catch {
            completionHandler(error)
            return
        }
        
        user = nil
        completionHandler(nil)
    }
}
