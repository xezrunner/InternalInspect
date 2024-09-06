import Foundation
import SwiftUI
import SystemColors

struct PacketGroupSection: View {
    init(_ group: PacketGroup) {
        self.group = group
    }
    
    @Namespace var packetList
    var group: PacketGroup
    
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        Section(group.handlePath) {
            ForEach(group.packets) { packet in
                NavigationLink {
                    if (!is_feature_flag_enabled("UseZoomTransitions")) {
                        PacketDetailView(packet: packet)
                    } else {
                        PacketDetailView(packet: packet)
#if !os(macOS)
                            .navigationTransition(.zoom(sourceID: packet.id, in: packetList))
#endif
                    }
                } label: { PacketListLabel(packet: packet) }
                    .matchedTransitionSource(id: packet.id, in: packetList)
            }
            .foregroundStyle((access(group.handlePath, F_OK) != 0) ? .secondary : .quaternary)
            .listRowBackground(is_feature_flag_enabled("UsePlainListBackground") ?
                               Color.systemBackground :
                                //Color.secondarySystemBackground.opacity(0.45) :
                               Color.systemBackground)
        }
        .monospaced()
        .font(.system(size: 12))
        .textCase(.none)
#if !os(macOS)
        .listSectionSpacing(0)
#endif
    }
}
