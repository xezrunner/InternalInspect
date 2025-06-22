import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(GlobalState.self) var globalState
    
    var body: some View {
        NavigationStack {
            ZStack {
                
#if os(macOS) || targetEnvironment(macCatalyst)
                macOSMainView()
#else
                UIKitMainView()
#endif
                
                AppLaunchUILayer()
                SettingsUILayer()
                DebugUILayer()
            }
        }
    }
    
#if false
    @Namespace var packetExpansion
    var body1: some View {
        ZStack {
            
            //            HeroExplainer(title:       "Internal states",
            //                          description: "A list of results from various functions that report internal and other relevant states.",
            //                          symbolName:  "wrench.and.screwdriver.fill")
            
            TabView {
                Group {
                    Tab("Packets", systemImage: "") {
                        NavigationStack {
                            List(selection: $globalState.packetSelection) {
                                ForEach(packetGroups) { group in
                                    PacketGroupSection(group)
                                }
                            }
                            .scrollContentBackground(is_feature_flag_enabled("UsePlainListBackground") ? .hidden : .visible)
                            .listSectionSpacing(.compact)
#if !os(macOS)
                            .shadow(color: .secondary.opacity(0.10), radius: 5, x: 0, y: 3)
#endif
                            .toolbar() {
                                MainToolbar()
                            }
                        }
                        
                    }
                    
                    Tab("Features", systemImage: "") {
                        EmptyView()
                            .toolbar() {
                                MainToolbar()
                            }
                    }
                }
                //                .navigationTitle("Internal states")
            }
            //            .tabViewStyle(SidebarAdaptableTabViewStyle())
            .tint(.primary)
            .toolbar() {
                MainToolbar()
            }
            
            AppLaunchUILayer()
            SettingsUILayer()
            DebugUILayer()
        }
    }
#endif
}

#Preview {
    ContentView()
        .environment(globalState)
}

