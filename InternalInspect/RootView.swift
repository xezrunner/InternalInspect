//
//  macOSMainView.swift
//  InternalInspect
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

struct RootView: View {
    @State var selectedTab: RootTab = .featureFlags
    
    @State var searchQuery: String = ""
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(RootTab.allCases.filter({ tab in
                AppFeatureFlag.enableGlobalSearch.value ? true : tab != .search
            })) { tab in
                Tab(tab.rawValue, systemImage: tab.icon, value: tab, role: tab.role) {
                    tab.view(searchQuery: $searchQuery)
                }
            }
        }
        .searchable(text: $searchQuery, placement: .toolbarPrincipal)
//        .tabViewStyle(.sidebarAdaptable)
        .availability_tabViewSolariumTweaks()
        .navigationSplitViewColumnWidth(min: 250, ideal: 300)
    }
}

extension View {
    @ViewBuilder func availability_tabViewSolariumTweaks() -> some View {
#if os(iOS)
        if #available(iOS 26.0, *) {
            self
                .tabBarMinimizeBehavior(.onScrollDown)
        } else { self }
#else
        self
#endif
    }
}
