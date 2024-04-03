//
//  SubscriptionManagerProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/04/2024.
//

import Foundation
import UIKit

protocol SubscriptionManagerProtocol {
    func productIdentifiers() -> [String]
    
    func requestProducts(_ completionHandler: @escaping () -> ())
    
    func subscriptionPurchased() -> Bool
}
