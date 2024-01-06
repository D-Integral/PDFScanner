//
//  AccountPresenter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation

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
               completionHandler: @escaping (Error?, User) -> ()) {
        interactor.logIn(withEmail: email,
                         password: password) { error, user in
            completionHandler(error,
                              user)
        }
    }
    
    func logOut(_ completionHandler: (Error?) -> ()) {
        interactor.logOut { error in
            completionHandler(error)
        }
    }
}
