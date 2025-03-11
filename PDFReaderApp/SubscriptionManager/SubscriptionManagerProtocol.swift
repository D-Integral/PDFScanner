//
//  SubscriptionManagerProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/04/2024.
//

import Foundation
import UIKit
//
protocol SubscriptionManagerProtocol {
    var subscriptionViewModel: SubscriptionViewModel { get }
    
    func productIdentifiers() -> [String]
    
    func requestProducts() async
    
    func subscriptionPurchased() -> Bool
    
    var openCount: Int { get }
    
    func incrementOpenCount()
    
    var daysInUsage: Int { get }
}
