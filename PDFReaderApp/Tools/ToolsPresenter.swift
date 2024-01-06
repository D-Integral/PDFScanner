//
//  ToolsPresenter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation

class ToolsPresenter: PresenterProtocol {
    let interactor: ToolsInteractor
    
    init(interactor: ToolsInteractor) {
        self.interactor = interactor
    }
    
    var title: String {
        return String(localized: "toolsTitle")
    }
}
