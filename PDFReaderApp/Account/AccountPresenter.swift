//
//  AccountPresenter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AccountPresenter: PresenterProtocol {
    private let interactor: AccountInteractor
    
    init(interactor: AccountInteractor) {
        self.interactor = interactor
    }
    
    var title: String {
        return interactor.userLogged ? String(localized: "myAccount") : String(localized: "logIn")
    }
    
    var userLogged: Bool {
        return interactor.userLogged
    }
    
    func onAppear() {
        interactor.startListen()
    }
    
    func onDisappear() {
        interactor.stopListen()
    }
    
    func logIn(withEmail email: String,
               password: String,
               completionHandler: @escaping (User, Error?) -> ()) {
        interactor.logIn(withEmail: email,
                         password: password) { user, error in
            completionHandler(user, error)
        }
    }
    
    func logIn(withCredential credential: AuthCredential,
               completionHandler: @escaping (User, Error?) -> ()) {
        interactor.logIn(withCredential: credential) { user, error in
            completionHandler(user, error)
        }
    }
    
    func logOut(_ completionHandler: (Error?) -> ()) {
        interactor.logOut { error in
            completionHandler(error)
        }
    }
}
