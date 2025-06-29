import SwiftUI

struct DebugSettingsView: View {
    @Environment(GlobalState.self) var globalState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        @Bindable var globalState = globalState
        
        Form {
            HeroExplainer(title: "Debug settings",
                          description: "Transient mode - changes will not persist!",
                          symbolName: "ant.circle.fill")
            
            Group {
                featureFlagsSection
            }
        }
    }
    
    func featureFlagsClearButton(flag: AppFeatureFlag) -> some View {
        Button(role: .destructive) {
            AppFeatureFlagOverrideSupport.shared?.clearFlag(flag: flag) ?? print("no overrides!")
        } label: {
            Label("Unset", systemImage: "xmark.circle")
        }
    }
    
    var featureFlagsSection: some View {
        Section("Feature flags") {
            List(AppFeatureFlag.allCases) { flag in
                let valueBinding = Binding(get: { flag.value }, set: {
                    newValue in AppFeatureFlagOverrideSupport.shared?.setFlag(flag: flag, value: newValue) }
                )
                
                let clearButton = featureFlagsClearButton(flag: flag)
                
                Toggle(isOn: valueBinding) {
                    Label {
                        VStack {
                            Text(flag.rawValue)
                            if let description = flag.description { Text(description) }
                        }
                    } icon: {
                        Image(systemName: flag.symbol)
                    }
                }
                .swipeActions(edge: .trailing) { clearButton }
                .contextMenu { clearButton }
            }
        }
    }
}

#Preview {
    DebugSettingsView()
        .environment(GlobalState())
}
