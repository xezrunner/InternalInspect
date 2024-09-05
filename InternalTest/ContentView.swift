import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var featureFlags: GlobalFeatureFlags
    
    @State var showDebugSheet   = false
    @State var showConsoleSheet = false
    
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
#if !os(macOS)
            .listSectionSpacing(.compact)
#endif
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showConsoleSheet = !showConsoleSheet }, label: {
                        Label("Console", systemImage: showConsoleSheet ? "ladybug.circle.fill" : "ladybug.circle")
                    })
                    .tint(.primary.opacity(0.3))
                    .sheet(isPresented: $showConsoleSheet) {
                        ZStack {
                            if colorScheme == .light { Color.white.ignoresSafeArea(.all) }
                            VStack {
                                List(0 ..< featureFlags.consoleLines.count, id: \.self) { index in
                                    let pair = featureFlags.consoleLines[index]
                                    VStack(alignment: .leading) {
                                        Text( pair.0).bold().font(.system(size: 12))
                                        Text( pair.1).font(.system(size: 10))
                                    }.listRowBackground(Color.clear)
                                }
                                .monospaced()
                                .scrollContentBackground(.hidden)
                            }
                            .overlay(PopupCloseOverlayButton())
                            .presentationBackground(.ultraThinMaterial)
                            .presentationDetents([.large])
#if os(visionOS) || targetEnvironment(macCatalyst)
                            .presentationDragIndicator(.hidden)
#endif
                        }
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showDebugSheet = !showDebugSheet }, label: {
                        Label("Debug settings", systemImage: showDebugSheet ? "ant.circle.fill" : "ant.circle")
                    })
                    .tint(.primary.opacity(0.3))
                    .sheet(isPresented: $showDebugSheet) {
                        ZStack {
                            if colorScheme == .light { Color.white.ignoresSafeArea(.all) }
                            DebugSettingsView()
                                .environmentObject(globalFeatureFlags)
                                .presentationDetents([.medium, .large])
                                .presentationBackground(.ultraThinMaterial)
#if os(visionOS) || targetEnvironment(macCatalyst)
                                .presentationDragIndicator(.hidden)
#endif
                        }
                    }
                }
            }
        }
        .navigationTitle("Internal states")
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalFeatureFlags())
}

