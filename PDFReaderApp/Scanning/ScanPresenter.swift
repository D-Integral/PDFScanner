//
//  ScanPresenter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import VisionKit

class ScanPresenter: PresenterProtocol {
    let interactor: ScanInteractor
    
    init(interactor: ScanInteractor) {
        self.interactor = interactor
    }
    
    var title: String {
        return String(localized: "scan")
    }
    
    var isDocumentCameraSupported: Bool {
        return VNDocumentCameraViewController.isSupported
    }
}
