//
//  SubscriptionManager.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/04/2024.
//

import Foundation
import StoreKit

class SubscriptionManager: SubscriptionManagerProtocol {
    func productIdentifiers() -> [String] {
        return Array(Subscription.store.productIdentifiers)
    }
    
    func requestProducts(_ completionHandler: @escaping () -> ()) {
        Subscription.store.requestProducts { success, products in
            if success {
                completionHandler()
            }
        }
    }
    
    func subscriptionPurchased() -> Bool {
        return Subscription.subscriptionPurchased()
    }
}
