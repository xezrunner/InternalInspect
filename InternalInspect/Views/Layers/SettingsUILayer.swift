import SwiftUI

struct SettingsUILayer: View {
    @Environment(GlobalState.self) var globalState
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        @Bindable var globalState = globalState
        
        ZStack {}
            .sheet(isPresented: $globalState.showSettings) {
                SettingsView()
                    .environment(globalState)
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
            .environment(globalState)
            .onAppear {
                globalState.showSettings = true
            }
    }
}
