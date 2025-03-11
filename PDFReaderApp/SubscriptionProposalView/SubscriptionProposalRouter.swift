//
//  SubscriptionProposalRouter.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 03/04/2024.
//

import Foundation
import UIKit
import SwiftUI

class SubscriptionProposalRouter: FullScreenRouter {
    let state: SubscriptionApplicationStateProtocol
    
    init(state: SubscriptionApplicationStateProtocol) {
        self.state = state
    }
    
    override func make() -> UIViewController {
        let subscriptionProposalView = SubscriptionProposalView(subscriptionViewModel: state.subscriptionViewModel)
        let hostingController = UIHostingController(rootView: subscriptionProposalView)
        
        return hostingController
    }
}
