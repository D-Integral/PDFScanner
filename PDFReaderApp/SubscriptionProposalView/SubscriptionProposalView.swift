//
//  SubscriptionProposalView.swift
//  PDF Reader
//
//  Created by Dmytro Skorokhod on 01/08/2023.
//

import SwiftUI
import StoreKit

struct SubscriptionProposalView: View {
    @ObservedObject var subscriptionViewModel: SubscriptionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var termsOfServicePresented: Bool = false
    @State var privacyPolicyPresented: Bool = false
    
    let subscriptionProposalString = AttributedString(
        localized: "subscriptionProposal",
        comment: "The subscription proposal"
    )
    
    var containerBackground: AnyGradient {
        return Color.init(.blue).gradient
    }
    
    var body: some View {
        NavigationStack {
            SubscriptionStoreView(productIDs: subscriptionViewModel.productIDs()) {
                ScrollView {
                    VStack {
                        Text(String(localized: "Your Support Makes All the Difference",
                                    comment: "Subscription title"))
                            .font(.largeTitle)
                            .fontWeight(.black)

                        Text(subscriptionProposalString)
                            .multilineTextAlignment(.center)
                    }
                    .foregroundStyle(.white)
                    .containerBackground(containerBackground,
                                         for: .subscriptionStore)
                }
            }
            .storeButton(.visible, for: .restorePurchases, .policies)
            .subscriptionStorePolicyForegroundStyle(.white)
            .subscriptionStorePolicyDestination(for: .privacyPolicy) {
                PrivacyPolicyView(privacyPolicyPresented: $privacyPolicyPresented,
                                  fullScreen: false)
            }
            .subscriptionStorePolicyDestination(for: .termsOfService) {
                TermsOfServiceView(termsOfServicePresented: $termsOfServicePresented,
                                   fullScreen: false)
            }
            .subscriptionStoreControlStyle(.prominentPicker)
            .onInAppPurchaseCompletion { product, error in
                Task {
                    if try await subscriptionViewModel.store.isPurchased(product) {
                        subscriptionViewModel.subscribe()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SubscriptionProposalView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionProposalView(subscriptionViewModel: SubscriptionViewModel())
    }
}
