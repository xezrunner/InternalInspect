import SwiftUI

struct MainToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            if false {
                Label("Test", systemImage: "questionmark.circle")
                    .disabled(true).opacity(0.25)
            }
            
            Menu(
                content: {
                    DebugMenu()
                },
                label: {
                    Label("Settings", systemImage: "gear")
                },
                primaryAction: {
                    // Settings!
                }
            )
        }
    }
}
