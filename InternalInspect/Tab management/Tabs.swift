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
    @ViewBuilder func view(searchQuery: Binding<String>) -> Content
    
    var icon:     String { get }
    
    var role: TabRole? { get }
}

public extension AppTab {
    var id: Self { self }
    var icon: String { get { return "gear" } }
    var role: TabRole? { get { nil }}
}

enum RootTab: String, AppTab {
    var id: Self { self }
    
    case packets      = "Packets"
    case featureFlags = "Feature flags"
    case settings     = "Settings"
    case search       = "Search"
    
    @ViewBuilder func view(searchQuery: Binding<String>) -> some View {
        switch self {
        case .packets:
            PacketsTab().environment(PacketsTabState())
        case .featureFlags:
            FeatureFlagsTab().environment(FeatureFlagsTabState())
        case .settings:
            DebugSettingsView()
        case .search:
            SearchTab(searchQuery: searchQuery).environment(SearchTabState())
        }
    }
    
    public var icon: String {
        switch self {
        case .search:       "magnifyingglass"
        case .packets:      "shippingbox"
        case .featureFlags: "flag.filled.and.flag.crossed"
        case .settings:     "gear"
        }
    }
    
    public var role: TabRole? {
        self == .search ? .search : nil
    }
}
