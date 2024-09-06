import SwiftUI

struct MainToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { }) {
                Label("Test", systemImage: "questionmark.circle")
            }.disabled(true)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { }) {
                Label("Settings", systemImage: "gear")
            }.disabled(true)
        }
    }
}
