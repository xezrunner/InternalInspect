import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var featureFlags: GlobalFeatureFlags
    
    @State var showDebugSheet   = false
    @State var showConsoleSheet = false
    
    var body: some View {
        NavigationStack {
            List() {
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
                
                ForEach(packetGroups) { group in
                    PacketGroupSectionView(group)
                }
            }
            .listSectionSpacing(.compact)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
                                        Text(pair.0).bold().font(.system(size: 12))
                                        Text(pair.1).font(.system(size: 10))
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showDebugSheet = !showDebugSheet }, label: {
                        Label("Debug settings", systemImage: showDebugSheet ? "ant.circle.fill" : "ant.circle")
                    })
                    .tint(.primary.opacity(0.3))
                    .sheet(isPresented: $showDebugSheet) {
                        ZStack {
                            if colorScheme == .light { Color.white.ignoresSafeArea(.all) }
                            DebugSettingsView()
                                .presentationDetents([.medium, .large])
                                .presentationBackground(.ultraThinMaterial)
#if os(visionOS) || targetEnvironment(macCatalyst)
                                .presentationDragIndicator(.hidden)
#endif
                        }
                    }
                }
                
                //                ToolbarItem(placement: .topBarTrailing) {
                //                    Button(action: {
                //                        alertMessage("Info", "This application lists functions that report internal status. They are called and their results are presented.")
                //                    }, label: {
                //                        Label("Internal states", systemImage: "info.circle")
                //                    })
                //                }
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
    }
}

@MainActor func alertMessage(_ title: String, _ message: String) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
    }
    alertVC.addAction(okAction)
    
    let viewController = UIApplication.shared.windows.first!.rootViewController!
    viewController.present(alertVC, animated: true, completion: nil)
}

#Preview {
    ContentView()
        .environmentObject(GlobalFeatureFlags())
}

