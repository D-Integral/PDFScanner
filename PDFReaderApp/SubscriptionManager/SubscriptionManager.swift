//
//  SubscriptionManager.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/04/2024.
//

import Foundation
import StoreKit

class SubscriptionManager: SubscriptionManagerProtocol {
    let subscriptionViewModel = SubscriptionViewModel()
    let openTracker = DocumentOpenTracker()
    
    func productIdentifiers() -> [String] {
        return subscriptionViewModel.productIDs()
    }
    
    func requestProducts() async {
        await subscriptionViewModel.requestProducts()
    }
    
    func subscriptionPurchased() -> Bool {
        return subscriptionViewModel.isSubscribed()
    }
    
    var openCount: Int {
        return openTracker.openCount
    }
    
    func incrementOpenCount() {
        openTracker.incrementOpenCount()
    }
}
