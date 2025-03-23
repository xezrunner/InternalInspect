//
//  Tabs.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

enum MainTab: String, CaseIterable, Identifiable, Hashable {
    var id: Self { self }
    
    case packets = "Packets"
    case featureFlags = "Feature flags"
    
    public var icon: String {
        switch self {
        case .packets:  "shippingbox"
        case .featureFlags: "flag.filled.and.flag.crossed"
        }
    }
    
    @MainActor @ViewBuilder
    public func view() -> some View {
        switch self {
        case .packets:  PacketsTabView()
        case .featureFlags: FeatureFlagsTabView()
        }
    }
}
