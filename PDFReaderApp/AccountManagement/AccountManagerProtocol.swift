//
//  AccountManagerProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

protocol AccountManagerProtocol {
    var currentUser: UserProtocol? { get }
    var userLogged: Bool { get }
    
    func startListen()
    func stopListen()
    
    func logIn(withEmail email: String,
               password: String,
               completionHandler: @escaping (User?, Error?) -> ())
    func signIn(withServiceProvider signInServiceProvider: SignInServiceProvider,
                completionHandler: @escaping (User?, Error?) -> ())
    func signUp(withEmail email: String,
                password: String,
                completionHandler: @escaping (User?, Error?) -> ())
    func logOut(_ completionHandler: (Error?) -> ())
}
