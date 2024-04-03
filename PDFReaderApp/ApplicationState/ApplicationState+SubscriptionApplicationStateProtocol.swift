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
    
    func checkIfSubscribed(subscribedCompletionHandler: () -> (),
                           notSubscribedCompletionHandler: () -> ()) {
        let subscriptionPurchased = subscriptionManager.subscriptionPurchased()
        
        if subscriptionPurchased {
            subscribedCompletionHandler()
        } else {
            notSubscribedCompletionHandler()
        }
    }
}
