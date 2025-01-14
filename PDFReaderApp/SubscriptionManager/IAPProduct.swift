//
//  IAPProduct.swift
//  PDF Reader
//
//  Created by Dmytro Skorokhod on 01/08/2023.
//

import Foundation
import StoreKit

class IAPProduct: Identifiable {
    let product: SKProduct
    
    init(product: SKProduct) {
        self.product = product
    }
    
    func priceWithCurrency() -> String {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        
        let formattedPrice = numberFormatter.string(from: product.price)
        
        return formattedPrice ?? "?"
    }
}
