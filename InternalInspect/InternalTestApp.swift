import SwiftUI

@main
struct InternalInspectApp: App {
    var body: some Scene {
        WindowGroup {
//            Scratch()
            ContentView()
                .environment(globalState)
                .frame(minWidth: 300)
        }
        .windowResizability(.contentSize)
    }
}

public func print(_ items: String..., filePath: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n") {
    let fileName = URL(fileURLWithPath: filePath).lastPathComponent
    let prefix = "\(fileName):\(line)::\(function)"
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print("\(prefix):\n\(output)\n", terminator: terminator)
    
    let consoleLineInfo = ConsoleLineInfo(fileName: fileName, functionName: function, lineNumber: line, text: output)
    DispatchQueue.main.async {
        globalState.consoleLines.append(consoleLineInfo)
    }
}


extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
