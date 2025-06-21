import SwiftUI

struct SettingsPacketGroupView: View {
    @Environment(GlobalState.self) var globalState
    
    @Binding var group: PacketGroup?
    
    var body: some View {
        
        if let group {
            Form {
                HeroExplainer(
                    title: "Packet group",
                    description: group.handlePath,
                    symbolName: "list.bullet.circle.fill")

                
            }
        } else {
            HeroExplainer(
                title: "Select a packet group.",
                description: "",
                symbolName: "xmark.circle",
                tint: .red
            )
        }
    }
}

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(GlobalState.self) var globalState
    
    @State var groupSelection: PacketGroup? = nil
    
    var body: some View {
        NavigationSplitView(
            columnVisibility: .constant(.all),
            sidebar: {
                List(selection: $groupSelection) {
                    HeroExplainer(title: "Application settings",
                                  description: "",
                                  symbolName: "gear.circle.fill")
                    
                    if (false) {
                        Section("General") {
                            Toggle("Test toggle #1", isOn: .constant(true))
                            Toggle("Test toggle #2", isOn: .constant(false))
                            Toggle("Test toggle #3", isOn: .constant(false))
                        }
                    }
                    
                    Section("Packet groups") {
                        // TODO: this doesn't look great as it blends in with the rest of the stuff!
                        DisclosureGroup {
                            Text("**Packet**: represents an individual piece of information to be requested from the system, such as an eligibility domain or a function and its arguments.")
                            Text("**Packet group**: a collection of packets.\nDepending on the type of group, the packets inside may be linked to the group's library.")
                        } label: {
                            Label("Terminology", systemImage: "info.circle.fill")
                                .foregroundStyle(.primary)
                        }
                        
                        ForEach(packetGroups) { group in
                            NavigationLink(value: group) {
                                Text(group.handlePath)
                                    .font(.system(size: 13))
                                    .monospaced()
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .toolbar(removing: .sidebarToggle)
            },
            detail: {
                SettingsPacketGroupView(group: $groupSelection)
            }
        )
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    SettingsView()
        .environment(GlobalState())
}
