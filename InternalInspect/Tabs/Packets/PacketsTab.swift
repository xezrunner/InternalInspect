//
//  PacketsTab.swift
//  InternalInspect
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

struct PacketsTab: View {
    @Environment(PacketsTabState.self) var packetsTabViewState
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "book.and.wrench.fill")
                .font(.system(size: 72))
            
            Text("Under Construction")
                .font(.title2)
        }
    }
}
