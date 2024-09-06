import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var globalState: GlobalState
    
    @Namespace var packetExpansion
    
    var body: some View {
        NavigationStack {
            List(selection: $globalState.packetSelection) {
                HeroExplainer(title:       "Internal states",
                              description: "A list of results from various functions that report internal and other relevant states.",
                              symbolName:  "gear.circle.fill")
                
                ForEach(packetGroups) { group in
                    PacketGroupSection(group)
                }
            }
            .scrollContentBackground(is_feature_flag_enabled("UsePlainListBackground") ? .hidden : .visible)
            .toolbar { MainToolbar() }
            .toolbar { is_feature_flag_enabled("EnableDebug") ? DebugToolbar() : nil }
            .shadow(color: .secondary.opacity(0.10), radius: 5, x: 0, y: 3)
#if !os(macOS)
            .listSectionSpacing(.compact)
#endif
        }
        .navigationTitle("Internal states")
    }
}

#Preview {
    ContentView()
        .environmentObject(globalState)
}

