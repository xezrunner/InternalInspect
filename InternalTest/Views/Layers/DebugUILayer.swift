import SwiftUI

struct DebugUILayer: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {}
            .sheet(isPresented: $globalState.showConsole) {
                ConsoleView()
                .overlay(PopupCloseOverlayButton())
                .presentationBackground(colorScheme == .light ? Color.white : Color.black)
                .presentationDetents([.large])
#if os(visionOS) || targetEnvironment(macCatalyst)
                .presentationDragIndicator(.hidden)
#endif
            }
            .sheet(isPresented: $globalState.showDebugSettings) {
                DebugSettingsView()
                    .overlay(PopupCloseOverlayButton())
                    .presentationDetents([.fraction(0.85), .large])
                    .presentationBackground(colorScheme == .light ? Color.white : Color.black)
#if os(visionOS) || targetEnvironment(macCatalyst)
                    .presentationDragIndicator(.hidden)
#endif
            }
    }
}
