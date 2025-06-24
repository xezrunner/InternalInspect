//
//  Tabs.swift
//  InternalInspect
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

public protocol AppTab: CaseIterable, Identifiable, Hashable, Equatable, RawRepresentable {
    var id: Self { get }
    
    associatedtype Content: View
    @ViewBuilder func view() -> Content
    
    var icon:     String { get }
}

public extension AppTab {
    var id: Self { self }
    var icon: String { get { return "gear" } }
}

enum RootTab: String, AppTab {
    var id: Self { self }
    
    case packets = "Packets"
    case featureFlags = "Feature flags"
//    case scratch = "Scratch"
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .packets:
            PacketsTab().environment(PacketsTabState())
        case .featureFlags:
            FeatureFlagsTab().environment(FeatureFlagsTabState())
//        case .scratch:
//            Scratch()
        }
    }
    
    public var icon: String {
        switch self {
        case .packets:  "shippingbox"
        case .featureFlags: "flag.filled.and.flag.crossed"
//        case .scratch: "pawprint"
        }
    }
}
