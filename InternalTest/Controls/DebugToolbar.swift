import SwiftUI

struct DebugToolbar: ToolbarContent {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var globalState: GlobalState
    
    @State var showDebugSheet   = false
    @State var showConsoleSheet = false
    
    var body: some ToolbarContent {
        // MARK: Console
        ToolbarItem(placement: .topBarLeading) {
            Button(action: { showConsoleSheet = !showConsoleSheet }, label: {
                Label("Console", systemImage: showConsoleSheet ? "ladybug.circle.fill" : "ladybug.circle")
            })
            .tint(.primary.opacity(0.3))
            .sheet(isPresented: $showConsoleSheet) {
                VStack {
                    List(0 ..< globalState.consoleLines.count, id: \.self) { index in
                        let pair = globalState.consoleLines[index]
                        VStack(alignment: .leading) {
                            Text(pair.0).bold().font(.system(size: 12))
                            Text(pair.1).font(.system(size: 10))
                        }.listRowBackground(Color.clear)
                    }
                    .monospaced()
                    .scrollContentBackground(.hidden)
                }
                .overlay(PopupCloseOverlayButton())
                //.presentationBackground(.ultraThinMaterial)
                .presentationBackground(colorScheme == .light ? Color.white : Color.black)
                .presentationDetents([.large])
#if os(visionOS) || targetEnvironment(macCatalyst)
                .presentationDragIndicator(.hidden)
#endif
            }
        }
        
        // MARK: Debug settings
        ToolbarItem(placement: .topBarLeading) {
            Button(action: { showDebugSheet = !showDebugSheet }, label: {
                Label("Debug settings", systemImage: showDebugSheet ? "ant.circle.fill" : "ant.circle")
            })
            .tint(.primary.opacity(0.3))
            .sheet(isPresented: $showDebugSheet) {
                DebugSettingsView()
                    .environmentObject(globalState)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(colorScheme == .light ? Color.white : Color.black)
                //.presentationBackground(.ultraThinMaterial)
#if os(visionOS) || targetEnvironment(macCatalyst)
                    .presentationDragIndicator(.hidden)
#endif
            }
        }
    }
}
