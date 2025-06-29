import SwiftUI

@Observable class GlobalState {
    var featureFlagsOverrides = AppFeatureFlagOverrideSupport()
    
    // MARK: - UI layers
    var showSettings:      Bool = false
    var showDebugSettings: Bool = false
    var showAppLaunch:     Bool = false
    
    // MARK: - App launch
    var appLaunchList: [String] = getAllApps()
    
    // MARK: - Console
    var showConsole: Bool = false
    var consoleLines: [ConsoleLineInfo] = [
        // ConsoleLineInfo(fileName: "testFile.swift", functionName: "test()", lineNumber: -1, text: "This is a test entry."),
        // ConsoleLineInfo(fileName: "testFile.swift", functionName: "test()", lineNumber: -1, text: "This is a slightly longer test entry."),
    ]
}

@MainActor var globalState = GlobalState()
