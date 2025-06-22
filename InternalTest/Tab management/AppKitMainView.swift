//
//  macOSMainView.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

struct macOSMainView: View {
    @State var selectedTab: MainTab = MainTab.featureFlags
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTab.allCases) { tab in
                Tab(tab.rawValue, systemImage: tab.icon, value: tab) {
                    tab.view()
                }
            }
        }
        .toolbar {
            MainToolbar()
        }
    }
}
