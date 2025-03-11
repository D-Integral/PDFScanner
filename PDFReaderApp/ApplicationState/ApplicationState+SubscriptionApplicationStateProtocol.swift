//
//  ApplicationState+SubscriptionApplicationStateProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/04/2024.
//

import Foundation

extension ApplicationState: SubscriptionApplicationStateProtocol {
    var productIdentifiers: [String] {
        return subscriptionManager.productIdentifiers()
    }
    
    func requestProducts() async {
        await subscriptionManager.requestProducts()
    }
    
    func checkIfSubscribed(subscribedCompletionHandler: () -> (),
                           notSubscribedCompletionHandler: () -> ()) {
        let subscriptionPurchased = subscriptionManager.subscriptionPurchased()
        
        if subscriptionPurchased {
            subscribedCompletionHandler()
        } else {
            notSubscribedCompletionHandler()
        }
    }
    
    var openCount: Int {
        return subscriptionManager.openCount
    }
    
    func incrementOpenCount() {
        subscriptionManager.incrementOpenCount()
    }
    
    var subscriptionViewModel: SubscriptionViewModel {
        return subscriptionManager.subscriptionViewModel
    }
    
    var daysInUsage: Int {
        return subscriptionManager.daysInUsage
    }
}
