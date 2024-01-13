//
//  PDFMakerProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 13/01/2024.
//

import Foundation
import UIKit

protocol PDFMakerProtocol {
    func generatePdfDocumentFile(from documentImages: [UIImage],
                                 completionHandler: @escaping ((any FileProtocol)?, Error?) -> ()) -> ()?
}
