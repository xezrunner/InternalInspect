import SwiftUI

// MARK: Global state
class GlobalState: ObservableObject {
    // MARK: Main
    @Published var packetSelection: Packet? = nil
    
    // MARK: Feature flags
    @Published var featureFlags = GlobalFeatureFlags()
    
    // MARK: UI layers
    @Published var showSettings:      Bool = false
    @Published var showDebugSettings: Bool = false
    @Published var showAppLaunch:     Bool = false
    
    // MARK: App launch
    @Published var appLaunchList: [String] = getAllApps()
    
    // MARK: Console
    @Published var showConsole: Bool = false
    @Published var consoleLines: [ConsoleLineInfo] = [
        // ConsoleLineInfo(fileName: "testFile.swift", functionName: "test()", lineNumber: -1, text: "This is a test entry."),
        // ConsoleLineInfo(fileName: "testFile.swift", functionName: "test()", lineNumber: -1, text: "This is a slightly longer test entry."),
    ]
}

@MainActor var globalState = GlobalState()
