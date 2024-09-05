import SwiftUI

nonisolated(unsafe) var globalFeatureFlags = GlobalFeatureFlags()

public func print(_ items: String..., filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n") {
    let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)"
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
    DispatchQueue.main.async {
        globalState.consoleLines.append((pretty, output))
    }
}

@main
struct InternalTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalState)
        }
    }
}
