import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var featureFlags: GlobalFeatureFlags
    
    @State var showDebugSheet   = false
    @State var showConsoleSheet = false
    
    var body: some View {
        NavigationStack {
            List() {
                if (featureFlags.getBool(name: "HideForPublicDemo")) {
                    VStack {
                        VStack(alignment: .center) {
                            Image(systemName: "eye.slash.circle.fill")
                                .resizable().aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .padding(.bottom, 2)
                            
                            Text("Gatekeeping").font(.headline).bold()
                            Text("Contents of this application have been hidden for so-called \"gatekeeping purposes\" (🙂‍↔️) and is unavailable to view on the platform you're seeing this on.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.top, 2)
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 8)
                    }
                } else {
                    VStack(alignment: .center) {
                        Image(systemName: "gear.circle.fill")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .padding(.bottom, 2)
                        
                        Text("Internal states").font(.headline).bold()
                        Text("A list of results from various functions that report internal and other relevant states.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 8)
                }
                
                ForEach(packetGroups) { group in
                    if (featureFlags.getBool(name: "HideForPublicDemo")) {
                        Section(group.id.uuidString) {
                            ForEach(group.packets) { packet in
                                NavigationLink(packet.id.uuidString, destination: { Text("Hidden!") })
                            }
                        }
                    } else {
                        PacketGroupSectionView(group)
                    }
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
                                let formatter = NumberFormatter()
                                List(0 ..< featureFlags.consoleLines.count, id: \.self) { index in
                                    let pair = featureFlags.consoleLines[index]
                                    VStack(alignment: .leading) {
                                        Text(featureFlags.getBool(name: "HideForPublicDemo") ? formatter.string(from: NSNumber(value: pair.0.hashValue))! : pair.0).bold().font(.system(size: 12))
                                        Text(featureFlags.getBool(name: "HideForPublicDemo") ? formatter.string(from: NSNumber(value: pair.0.hashValue))! : pair.1).font(.system(size: 10))
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
            /*
             .safeAreaInset(edge: .top) {
             HStack {
             Spacer()
             
             Spacer()
             Spacer()
             }
             .padding()
             .background(.ultraThinMaterial)
             }
             */
        }
        .navigationTitle(featureFlags.getBool(name: "HideForPublicDemo") ? "<private>" : "Internal states")
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalFeatureFlags())
}

