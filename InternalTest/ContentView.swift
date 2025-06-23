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
}

#Preview {
    ContentView()
        .environment(globalState)
}

