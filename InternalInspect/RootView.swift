//
//  macOSMainView.swift
//  InternalInspect
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

struct RootView: View {
    @State var selectedTab: RootTab = .featureFlags
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(RootTab.allCases) { tab in
                Tab(tab.rawValue, systemImage: tab.icon, value: tab) {
                    tab.view()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .availability_tabViewSolariumTweaks()
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
