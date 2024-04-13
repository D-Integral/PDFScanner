//
//  SubscriptionProposalRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/04/2024.
//

import Foundation
import UIKit
import SwiftUI

class SubscriptionProposalRouter: RouterProtocol {
    let state: SubscriptionApplicationStateProtocol
    
    init(state: SubscriptionApplicationStateProtocol) {
        self.state = state
    }
    
    func make() -> UIViewController {
//        let subscriptionProposalView = SubscriptionProposalView(state: state)
//        let hostingController = UIHostingController(rootView: subscriptionProposalView)
//        
//        return hostingController
        
        return UIViewController()
    }
}
