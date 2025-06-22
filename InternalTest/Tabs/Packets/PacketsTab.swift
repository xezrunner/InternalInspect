//
//  PacketsTab.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

struct PacketGroupDetailView: View {
    @Binding var group: PacketGroup?
    
    var body: some View {
        if let group = group {
            List(group.packets) { packet in
                Text(packet.funcName)
            }
        } else {
            
        }
    }
}

struct PacketsTab: View {
    @Environment(PacketsTabState.self) var packetsTabViewState
    
    var body: some View {
        @Bindable var state = packetsTabViewState
        let selectedGroupBinding = $state.selectedPacketGroup
        
        NavigationSplitView {
            List(packetGroups, selection: selectedGroupBinding) { group in
                NavigationLink(group.handlePath, value: group)
            }
            .toolbar(removing: .sidebarToggle)
        } detail: {
            PacketGroupDetailView(group: selectedGroupBinding)
        }
        .navigationSplitViewStyle(.balanced)
    }
}
