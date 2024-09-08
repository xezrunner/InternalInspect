import SwiftUI

struct DebugMenu: View {
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        Section("Debug") {
            Button(action: { globalState.showConsole = true }) {
                Label("Console", systemImage: "apple.terminal.fill")
            }
            Button(action: { globalState.showDebugSettings = true }) {
                Label("Debug settings", systemImage: "ant.fill")
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
                ConsoleView()
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
