import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(GlobalState.self) var globalState
    
    var body: some View {
        RootView()
        .overlay {
            AppLaunchUILayer()
            SettingsUILayer()
            DebugUILayer()
        }
    }
}

#Preview {
    ContentView()
        .environment(globalState)
}

