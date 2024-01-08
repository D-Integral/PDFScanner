//
//  PDFDocumentRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 04/01/2024.
//

import Foundation
import UIKit

class PDFDocumentRouter: DocumentRouter {
    func make(diskFile: DiskFile) -> UIViewController {
        let pdfDocumentViewController = PDFDocumentViewController(diskFile: diskFile)
        pdfDocumentViewController.title = diskFile.name
        
        return navigationController(with: pdfDocumentViewController)
    }
}
