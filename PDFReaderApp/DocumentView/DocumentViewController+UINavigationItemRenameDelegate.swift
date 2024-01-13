//
//  DocumentViewController+UINavigationItemRenameDelegate.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 13/01/2024.
//

import Foundation
import UIKit

extension DocumentViewController: UINavigationItemRenameDelegate {
    func navigationItem(_: UINavigationItem, didEndRenamingWith title: String) {
    }
    
    func navigationItemShouldBeginRenaming(_: UINavigationItem) -> Bool {
        return true
    }
    
    func navigationItem(_: UINavigationItem, willBeginRenamingWith suggestedTitle: String, selectedRange: Range<String.Index>) -> (String, Range<String.Index>) {
        return (suggestedTitle, selectedRange)
    }
    
    func navigationItem(_: UINavigationItem, shouldEndRenamingWith title: String) -> Bool {
        return true
    }
}
