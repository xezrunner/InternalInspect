//
//  iOSMainView.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

//#if os(macOS)
//let tabDebugPlacement = ToolbarItemPlacement.principal
//#else
//let tabDebugPlacement =
//    horizontalSizeClass == .compact ? ToolbarItemPlacement.bottomBar : .principal
//#endif
//ToolbarItemGroup(placement: tabDebugPlacement) {
//    Text("tab: \(selectedTab.rawValue) [\(selectedTab.id) | \(selectedTab.hashValue)]")
//        .font(.footnote)
//        .monospaced()
////                        .background(.regularMaterial)
//}

struct UIKitMainView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State var selectedTab: MainTab = .featureFlags
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTab.allCases) { tab in
                Tab(tab.rawValue, systemImage: tab.icon, value: tab) {
                    tab.view()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .toolbar {
            MainToolbar()
        }
    }
}
