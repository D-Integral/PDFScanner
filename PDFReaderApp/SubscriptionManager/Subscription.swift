//
//  Subscription.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/04/2024.
//

import Foundation

public struct Subscription {
    public static let monthlySubscriptionAppStoreIdentifier = "com.dintegralas.pdfscannerpremium.monthly"
    public static let yearlySubscriptionAppStoreIdentifier = "com.dintegralas.pdfscannerpremium.yearly"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [Subscription.monthlySubscriptionAppStoreIdentifier,
                                                                     Subscription.yearlySubscriptionAppStoreIdentifier]
    
    public static let store = IAPHelper(productIds: Subscription.productIdentifiers)
    
    static func subscriptionPurchased() -> Bool {
        let monthlyPurchased = store.isProductPurchased(monthlySubscriptionAppStoreIdentifier)
        let yearlyPurchased = store.isProductPurchased(yearlySubscriptionAppStoreIdentifier)
        
        return monthlyPurchased || yearlyPurchased
    }
}
