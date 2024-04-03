//
//  SubscriptionProposalView.swift
//  PDF Reader
//
//  Created by Dmytro Skorokhod on 01/08/2023.
//

import SwiftUI
import StoreKit

struct SubscriptionProposalView: View {
    let state: SubscriptionApplicationStateProtocol?
    
    weak var hostingController: UIViewController? = nil
    
    let subscriptionProposalString = AttributedString(
        localized: "Scan PDF documents like a pro with PDF Document Scanner subscription.",
        comment: "The subscription proposal string."
    )
    
    var body: some View {
        SubscriptionStoreView(productIDs: state?.productIdentifiers ?? []) {
            VStack {
                Text("PDF Document Scanner")
                    .font(.largeTitle)
                    .fontWeight(.black)

                Text(subscriptionProposalString)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(.white)
            .containerBackground(.blue.gradient, for: .subscriptionStore)
        }
        .storeButton(.visible, for: .restorePurchases, .policies, .cancellation)
        .subscriptionStorePolicyForegroundStyle(.white)
        .subscriptionStorePolicyDestination(for: .privacyPolicy) {
            Text("Privacy policy here")
        }
        .subscriptionStorePolicyDestination(for: .termsOfService) {
            Text("Terms of service here")
        }
        .subscriptionStoreControlStyle(.prominentPicker)
    }
}

struct SubscriptionProposalView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionProposalView(state: nil)
    }
}
