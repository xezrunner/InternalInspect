import SwiftUI

// MARK: Global state
class GlobalState: ObservableObject {
    // MARK: Main
    @Published var packetSelection: Packet? = nil
    
    // MARK: Console
    @Published var showConsole: Bool = false
    @Published var consoleLines: [(String, String)] = []
    
    public func addConsoleLine(text: (String, String)) {
        consoleLines.append(text)
    }
    
    // MARK: Debug settings
    @Published var showDebugSettings: Bool = false
    
    // MARK: Feature flags
    @Published var featureFlags = GlobalFeatureFlags()
}

@MainActor var globalState = GlobalState()
