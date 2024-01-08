//
//  PDFSelection+Comparable.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 25/05/2023.
//

import Foundation
import PDFKit

extension PDFSelection: Comparable {
    public static func < (leftSelection: PDFSelection, rightSelection: PDFSelection) -> Bool {
        let leftSelectionPage = leftSelection.pages[0]
        let rightSelectionPage = rightSelection.pages[0]
        let leftSelectionPageNumber = leftSelectionPage.pageRef?.pageNumber ?? 0
        let rightSelectionPageNumber = rightSelectionPage.pageRef?.pageNumber ?? 0
        
        if leftSelectionPageNumber == rightSelectionPageNumber {
            let leftBoundsY = leftSelection.bounds(for: leftSelectionPage).minY
            let rightBoundsY = rightSelection.bounds(for: rightSelectionPage).minY
            
            return leftBoundsY > rightBoundsY
        }
        
        return leftSelectionPageNumber < rightSelectionPageNumber
    }
}
