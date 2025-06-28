import SwiftUI

struct FeatureFlag: Identifiable {
    init(name: String, description: String = "", symbol: String = "", value: Bool) {
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
        FeatureFlag(name: "EnableGlobalSearch",
                    description: "Enable global search tab and behavior.",
                    symbol: "magnifyingglass.circle.fill",
                    value: false),
        
        FeatureFlag(name: "ShowDebugInformation",
                    description: "Show additional debugging information about packets.",
                    symbol: "square.stack.3d.up.trianglebadge.exclamationmark.fill",
                    value: false),
        
        FeatureFlag(name: "UseZoomTransitions",
                    description: "Use the new WWDC24 zoom transitions.",
                    symbol: "square.arrowtriangle.4.outward",
                    value: true),
        
        FeatureFlag(name: "NoHeroBackplate",
                    description: "Use transparent backgrounds on heroes",
                    symbol: "light.panel",
                    value: true),
        
        FeatureFlag(name: "UsePlainListBackground",
                    description: "Use a plain white/black color for the main list background",
                    symbol: "square.fill",
                    value: true),
        
        FeatureFlag(name: "UseLegacyListItem",
                    description: "Use the previous packet list item style",
                    symbol:"testtube.2",
                    value:false),
        
        FeatureFlag(name: "ExampleFlag",
                    description: "No symbol.",
                    value: false),
        
        FeatureFlag(name: "EnableDebug",
                    description: "⚠️ Disabling this not easily reversible, unless session is transient.",
                    symbol: "ant",
                    value: true),
    ]
}

@MainActor func is_feature_flag_enabled(_ name: String) -> Bool {
    let flag = globalState.featureFlags.flags.first(
        where: { (flag) -> Bool in return flag.name == name }
    )
    return flag?.value ?? false
}
