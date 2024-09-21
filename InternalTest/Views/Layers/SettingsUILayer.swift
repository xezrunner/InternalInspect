import SwiftUI

struct SettingsUILayer: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {}
            .sheet(isPresented: $globalState.showSettings) {
                SettingsView()
                    .overlay(PopupCloseOverlayButton())
                    .presentationBackground(colorScheme == .light ? Color.white : Color.black)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.85), .large])
            }
    }
}

#Preview {
    let globalState = GlobalState()
    
    VStack {
        Button("Show settings") {
            globalState.showSettings = true
        }.buttonStyle(.bordered)
        
        SettingsUILayer()
            .environmentObject(globalState)
            .onAppear {
                globalState.showSettings = true
            }
    }
}
