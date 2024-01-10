//
//  ScanRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import UIKit

class ScanRouter: RouterProtocol {
    func make() -> UIViewController {
        let interactor = ScanInteractor()
        let presenter = ScanPresenter(interactor: interactor)
        
        return ScanViewController(presenter: presenter)
    }
}
