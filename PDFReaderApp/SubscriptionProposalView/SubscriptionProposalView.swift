//
//  SubscriptionProposalView.swift
//  PDF Reader
//
//  Created by Dmytro Skorokhod on 01/08/2023.
//

//import SwiftUI
//import StoreKit
//
//struct SubscriptionProposalView: View {
//    let state: SubscriptionApplicationStateProtocol?
//    
//    weak var hostingController: UIViewController? = nil
//    
//    let subscriptionProposalString = AttributedString(
//        localized: "Scan PDF documents like a pro with PDF Document Scanner subscription.",
//        comment: "The subscription proposal string."
//    )
//    
//    var body: some View {
//        SubscriptionStoreView(productIDs: state?.productIdentifiers ?? []) {
//            VStack {
//                Text("PDF Document Scanner")
//                    .font(.largeTitle)
//                    .fontWeight(.black)
//
//                Text(subscriptionProposalString)
//                    .multilineTextAlignment(.center)
//            }
//            .foregroundStyle(.white)
//            .containerBackground(.blue.gradient, for: .subscriptionStore)
//        }
//        .storeButton(.visible, for: .restorePurchases, .policies, .cancellation)
//        .subscriptionStorePolicyForegroundStyle(.white)
//        .subscriptionStorePolicyDestination(for: .privacyPolicy) {
//            Text("We collect crash and usage data. Crash and usage reports are using to improve the app. For those purposes we use Firebase Analytics (a Google service).").padding(EdgeInsets(top: 15.0, leading: 15.0, bottom: 15.0, trailing: 15.0))
//        }
//        .subscriptionStorePolicyDestination(for: .termsOfService) {
//            Text("Dmytro Skorokhod is the owner of this application. You may scan and preview documents for free, but for sharing, saving, editing and/or signing you need a subscription. The devices compatible with the scanning feature: an iPhone or iPad running iOS 17 or later with an A12 Bionic processor or better (from late 2017).").padding(EdgeInsets(top: 15.0, leading: 15.0, bottom: 15.0, trailing: 15.0))
//        }
//        .subscriptionStoreControlStyle(.prominentPicker)
//    }
//}
//
//struct SubscriptionProposalView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscriptionProposalView(state: nil)
//    }
//}
