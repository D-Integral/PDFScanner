//
//  AppStoreExtension.swift
//  PDF Reader
//
//  Created by Dmytro Skorokhod on 09.01.2025.
//

import StoreKit
#if os(macOS)
import AppKit
#endif

extension AppStore {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            Task {
                await MainActor.run {
                    requestReview(in: scene)
                }
            }
        }
    }
}
