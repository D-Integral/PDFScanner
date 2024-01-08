//
//  DynamicUINotifier.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 08/01/2024.
//

import Foundation
import UIKit

class DynamicUINotifier: NSObject {
    private var dynamicUserInterfaces = [Weak<UIViewController>]()
    
    func add(dynamicUI: any DynamicUIProtocol) {
        guard let viewController = dynamicUI as? UIViewController else {
            return
        }
        
        dynamicUserInterfaces.append(Weak(value: viewController))
    }
    
    func remove(dynamicUI: any DynamicUIProtocol) {
        guard let viewController = dynamicUI as? UIViewController else {
            return
        }
        
        var index = -1
        
        for (currentIndex, currentWeakDynamicUI) in dynamicUserInterfaces.enumerated() {
            let currentDynamicUI = currentWeakDynamicUI.value
            
            if currentDynamicUI == viewController {
                index = currentIndex
            }
        }
        
        if index >= 0 {
            dynamicUserInterfaces.remove(at: index)
        }
    }
    
    func updateUI() {
        for weakDynamicUI in Array(dynamicUserInterfaces) {
            guard let viewController = weakDynamicUI.value else {
                continue
            }
            
            viewController.updateDynamicUI()
        }
    }
    
    func timeConsumingOperationStarted() {
        for weakDynamicUI in Array(dynamicUserInterfaces) {
            guard let viewController = weakDynamicUI.value else {
                continue
            }
            
            viewController.timeConsumingOperationStarted()
        }
    }
    
    func timeConsumingOperationCompleted() {
        for weakDynamicUI in Array(dynamicUserInterfaces) {
            guard let viewController = weakDynamicUI.value else {
                continue
            }
            
            viewController.timeConsumingOperationCompleted()
        }
    }
}
