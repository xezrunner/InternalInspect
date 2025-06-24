import SwiftUI

struct MainToolbar: ToolbarContent {
    @Environment(GlobalState.self) var globalState
    
    var body: some ToolbarContent {
        #if true
        ToolbarItemGroup {
            Button("Launch application by ID", systemImage: "list.bullet") {
                globalState.showAppLaunch = true
            }
            
            Menu {
                DebugMenu()
            } label: {
                Label("Settings", systemImage: "gear")
            } primaryAction: {
                globalState.showSettings = true
            }
        }
        #else
        ToolbarItemGroup(placement: .primaryAction) {
            if false {
                Label("Test", systemImage: "questionmark.circle")
                    .disabled(true).opacity(0.25)
            }
            
            Label("App launch test", systemImage: "list.bullet")
                .onTapGesture {
                    globalState.showAppLaunch = true
                }
            
            Menu(
                content: {
                    DebugMenu()
                },
                label: {
                    Label("Settings", systemImage: "gear")
                },
                primaryAction: {
                    globalState.showSettings = true
                }
            )
        }
        #endif
    }
}
