//
//  PacketsTab.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

@Observable class PacketsTabViewGlobalState {
    var selectedPacketGroup: PacketGroup?
}

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

struct PacketsTabView: View {
    @Environment(GlobalState2.self) var globalState: GlobalState2
    
    var body: some View {
        @Bindable var globalState = globalState
        let selectedGroupBinding = $globalState.packetsTabViewState.selectedPacketGroup
        
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
