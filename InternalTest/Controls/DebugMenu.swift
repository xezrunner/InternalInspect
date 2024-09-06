import SwiftUI

struct DebugMenu: View {
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        Section("Debug") {
            Button(action: { globalState.showConsole = true }) {
                Label("Console", systemImage: "ladybug.circle")
            }
            Button(action: { globalState.showDebugSettings = true }) {
                Label("Debug settings", systemImage: "ant.circle")
            }
        }
        Section("Build number") {
            Text(Bundle.main.buildVersionNumber ?? "???")
        }
    }
}

struct DebugView: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {}
            .sheet(isPresented: $globalState.showConsole) {
                VStack {
                    List(0 ..< globalState.consoleLines.count, id: \.self) { index in
                        let pair = globalState.consoleLines[index]
                        VStack(alignment: .leading) {
                            Text(pair.0).bold().font(.system(size: 12))
                            Text(pair.1).font(.system(size: 10))
                        }.listRowBackground(Color.clear)
                    }
                    .monospaced()
                    .scrollContentBackground(.hidden)
                }
                .overlay(PopupCloseOverlayButton())
                //.presentationBackground(.ultraThinMaterial)
                .presentationBackground(colorScheme == .light ? Color.white : Color.black)
                .presentationDetents([.large])
#if os(visionOS) || targetEnvironment(macCatalyst)
                .presentationDragIndicator(.hidden)
#endif
            }
            .sheet(isPresented: $globalState.showDebugSettings) {
                DebugSettingsView()
                    .environmentObject(globalState)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(colorScheme == .light ? Color.white : Color.black)
                //.presentationBackground(.ultraThinMaterial)
#if os(visionOS) || targetEnvironment(macCatalyst)
                    .presentationDragIndicator(.hidden)
#endif
            }
    }
}
