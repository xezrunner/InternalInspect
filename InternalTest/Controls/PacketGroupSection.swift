import Foundation
import SwiftUI
import SystemColors

struct PacketGroupSection: View {
    init(_ group: PacketGroup) {
        self.group = group
    }
    
    @EnvironmentObject var globalState: GlobalState
    
    @Namespace var packetExpansion
    var group: PacketGroup
        
    @State var selection: Int? = nil
    
    var body: some View {
        Section(group.handlePath) {
            ForEach(group.packets) { packet in
                NavigationLink(
                    destination: {
                        if (!is_feature_flag_enabled("UseZoomTransitions")) {
                            PacketDetailView(packet: packet)
                        } else {
                            PacketDetailView(packet: packet)
    #if !os(macOS)
                                .navigationTransition(.zoom(sourceID: packet.id, in: packetExpansion))
    #endif
                        }
                    },
                    label: {
                        PacketListLabel(packet: packet)
                    }
                )
                .matchedTransitionSource(id: packet.id, in: packetExpansion)
            }
            .foregroundStyle((access(group.handlePath, F_OK) != 0) ? .secondary : .quaternary)
        }
        .monospaced()
        .font(.system(size: 12))
        .textCase(.none)
#if !os(macOS)
        .listSectionSpacing(0)
#endif
    }
}
