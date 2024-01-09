//
//  DocumentViewController+UIGestureRecognizerDelegate.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 09/01/2024.
//

import Foundation
import UIKit

extension DocumentViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if searchResultsView.frame.contains(touch.location(in: view)) {
            return false
        }
        
        return true
    }
}
