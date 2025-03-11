//
//  PrivacyPolicyView.swift
//  PDF Reader
//
//  Created by Dmytro Skorokhod on 06.01.2025.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Binding var privacyPolicyPresented: Bool
    var fullScreen = true
    
    var body: some View {
        return GeometryReader { geometry in
            ScrollView {
                Text(String(localized: "privacyPolicy",
                            comment: "The provacy policy."))
                .lineLimit(nil)
                .frame(width: geometry.size.width)
            }
            .toolbar {
                if fullScreen {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button(action: close) {
                            Label("Close", systemImage: "xmark")
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "privacyPolicyTitle",
                                    comment: "The title for the privacy policy."))
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    private func close() {
        privacyPolicyPresented = false
    }
}

#Preview {
    @Previewable @State var privacyPolicyPresented = false
    
    PrivacyPolicyView(privacyPolicyPresented: $privacyPolicyPresented)
}
