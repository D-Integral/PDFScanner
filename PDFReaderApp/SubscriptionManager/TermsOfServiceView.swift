//
//  TermsOfServiceView.swift
//  PDF Reader
//
//  Created by Dmytro Skorokhod on 06.01.2025.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Binding var termsOfServicePresented: Bool
    var fullScreen = true
    
    var body: some View {
        return GeometryReader { geometry in
            ScrollView {
                Text(String(localized: "termsOfService",
                            comment: "The terms of service."))
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
            .navigationTitle(String(localized: "termsOfServiceTitle",
                                    comment: "The title for the terms of service"))
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    private func close() {
        termsOfServicePresented = false
    }
}

#Preview {
    @Previewable @State var termsOfServicePresented = false
    
    TermsOfServiceView(termsOfServicePresented: $termsOfServicePresented)
}
