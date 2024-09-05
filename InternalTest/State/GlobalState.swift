import SwiftUI

// MARK: Global state
class GlobalState: ObservableObject {
    // MARK: Console
    @Published var consoleLines: [(String, String)] = []
    
    public func addConsoleLine(text: (String, String)) {
        consoleLines.append(text)
    }
    
    // MARK: Feature flags
    @Published var featureFlags = GlobalFeatureFlags()
}

@MainActor var globalState = GlobalState()

// MARK: Miscellaneous

@MainActor func is_feature_flag_enabled(_ name: String) -> Bool {
    let flag = globalState.featureFlags.flags.first(
        where: { (flag) -> Bool in return flag.name == name }
    )
    return flag?.value ?? false
}
