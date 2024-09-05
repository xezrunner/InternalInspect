import SwiftUI

struct FeatureFlag: Identifiable {
    init(name: String, description: String, symbol: String = "", value: Bool) {
        self.name = name
        self.description = description
        self.symbol = symbol
        self.value = value
    }
    
    let id: UUID = UUID()
    let name: String
    let description: String
    let symbol: String
    var value: Bool
}

struct GlobalFeatureFlags {
    var flags: [FeatureFlag] = [
        FeatureFlag(name: "ShowDebugInformation",
                    description: "Show additional debugging information about packets.",
                    symbol: "square.stack.3d.up.trianglebadge.exclamationmark.fill",
                    value: false),
        
        FeatureFlag(name: "UseZoomTransitions",
                    description: "Use the new WWDC24 zoom transitions.",
                    symbol: "square.arrowtriangle.4.outward",
                    value: false),
        
        FeatureFlag(name: "ExampleFlag",
                    description: "No symbol.",
                    value: false),
    ]
}
