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
    var userLogged: Bool { get }
    
    func startListen()
    func stopListen()
    
    func logIn(withEmail email: String,
               password: String,
               completionHandler: @escaping (User, Error?) -> ())
    func logIn(withCredential credential: AuthCredential,
               completionHandler: @escaping (User, Error?) -> ())
    func signUp(withEmail email: String,
                password: String,
                completionHandler: @escaping (User, Error?) -> ())
    func logOut(_ completionHandler: (Error?) -> ())
}
