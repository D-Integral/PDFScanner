//
//  SubscriptionApplicationStateProtocol.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/04/2024.
//

import Foundation

protocol SubscriptionApplicationStateProtocol {
    var productIdentifiers: [String] { get }
    
    func requestProducts() async
    
    func checkIfSubscribed(subscribedCompletionHandler: () -> (),
                           notSubscribedCompletionHandler: () -> ())
    
    var openCount: Int { get }
    
    func incrementOpenCount()
    
    var subscriptionViewModel: SubscriptionViewModel { get }
}
