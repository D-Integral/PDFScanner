//
//  MyFilesViewController+UICollectionViewDelegate.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 04/01/2024.
//

import Foundation
import UIKit

extension MyFilesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath
    ) {
        guard let diskFile = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        pdfDocumentRouter?.diskFile = diskFile
        
        guard let pdfDocumentViewController = pdfDocumentRouter?.make() else { return }
        
        let fileId = diskFile.id
        
        navigationController?.present(pdfDocumentViewController,
                                      animated: true,
                                      completion: { [weak self] in
            self?.presenter?.openedFile(withId: fileId)
        })
    }
}
