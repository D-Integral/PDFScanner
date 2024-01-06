//
//  AccountManagerProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation

protocol AccountManagerProtocol {
    var userLogged: Bool { get }
    
    func startListen()
    func stopListen()
    
    func logIn(withEmail email: String,
               password: String,
               completionHandler: @escaping (Error?,
                                             User) -> ())
    func signUp(withEmail email: String,
                password: String,
                completionHandler: @escaping (Error?,
                                              User) -> ())
    func logOut(_ completionHandler: (Error?) -> ())
}
