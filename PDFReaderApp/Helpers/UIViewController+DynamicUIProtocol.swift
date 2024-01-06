//
//  UIViewController+DynamicUIProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/01/2024.
//

import Foundation
import UIKit

extension UIViewController: DynamicUIProtocol {
    func updateDynamicUI() { }
    func timeConsumingOperationStarted() { }
    func timeConsumingOperationCompleted() { }
}
