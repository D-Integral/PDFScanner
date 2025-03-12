//
//  AppViewModel.swift
//  PDF Reader
//
//  Created by Dmytro Skorokhod on 09.10.2024.
//

import Foundation
import Combine
import Network

import Foundation

class SubscriptionViewModel: ObservableObject {
    private let subscriptionKey = "isSubscribed"
    let userDefaults = UserDefaults.standard
    var openTracker = DocumentOpenTracker()
    
    let store = Store()
    
    func productIDs() -> [String] {
        let products = store.subscriptions
        
        var result = [String]()
        
        for product in products {
            result.append(product.id)
        }
        
        return result
    }
    
    func subscribe() {
        // Update the subscription status using UserDefaults
        userDefaults.set(true, forKey: subscriptionKey)
    }
    
    func unsubscribe() {
        // Optionally handle unsubscription
        userDefaults.set(false, forKey: subscriptionKey)
    }
    
    func isSubscribed() -> Bool {
        // Retrieve the current subscription status
        return userDefaults.bool(forKey: subscriptionKey)
    }
    
    func requestProducts() async {
        await store.requestProducts()
        
        var anyProductPurchased = false
        
        if store.subscriptions.count > 0 {
            for subscription in store.subscriptions {
                Task {
                    if try await store.isPurchased(subscription) {
                        subscribe()
                        anyProductPurchased = true
                    }
                }
            }
        }
        
        if !anyProductPurchased {
            unsubscribe()
        }
    }
}
