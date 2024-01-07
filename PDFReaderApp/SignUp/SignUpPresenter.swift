//
//  SignUpPresenter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation

class SignUpPresenter: PresenterProtocol {
    let interactor: SignUpInteractor
    
    init(interactor: SignUpInteractor) {
        self.interactor = interactor
    }
    
    var title: String {
        return String(localized: "signUp")
    }
    
    func signUp(withEmail email: String,
                password: String,
                completionHandler: @escaping (User?, Error?) -> ()) {
        interactor.signUp(withEmail: email,
                          password: password) { user, error in
            completionHandler(user, error)
        }
    }
}
