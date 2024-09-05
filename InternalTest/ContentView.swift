import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        NavigationStack {
            List() {
                HeroExplainer(title:       "Internal states",
                              description: "A list of results from various functions that report internal and other relevant states.",
                              symbolName:  "gear.circle.fill")
                
                
                ForEach(packetGroups) { group in
                    PacketGroupSectionView(group)
                }
            }
            .toolbar{DebugToolbar()}
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

