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
