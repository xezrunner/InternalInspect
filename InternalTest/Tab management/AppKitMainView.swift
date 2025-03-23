//
//  macOSMainView.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

struct macOSMainView: View {
    @State var selectedTab: MainTab? = MainTab.packets.id
    
    var body: some View {
        NavigationSplitView {
            List(MainTab.allCases, selection: $selectedTab) { tab in
                Text(tab.rawValue)
            }
        } detail: {
            selectedTab?.view()
        }
    }
}
