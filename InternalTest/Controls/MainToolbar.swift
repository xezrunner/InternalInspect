import SwiftUI

struct MainToolbar: ToolbarContent {
    @EnvironmentObject var globalState: GlobalState
    
    var body: some ToolbarContent {
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
    }
}
