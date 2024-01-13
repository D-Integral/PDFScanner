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
        return String(localized: "myAccount")
    }
}
