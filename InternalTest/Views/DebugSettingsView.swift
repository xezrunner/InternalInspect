import SwiftUI

struct DebugSettingsView: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            HeroExplainer(title: "Debug settings",
                          description: "Transient mode - changes will not persist!",
                          symbolName: "ant.circle.fill")
            
            Section("Feature flags") {
                ForEach(0 ..< globalState.featureFlags.flags.count, id: \.self) { index in
                    let flag      = globalState.featureFlags.flags[index]
                    let flagValue = $globalState.featureFlags.flags[index].value
                    
                    Toggle(isOn: flagValue, label: {
                        Label(title: {
                            VStack(alignment: .leading) {
                                Text(flag.name).font(.subheadline).bold().monospaced()
                                Text(flag.description).font(.footnote)
                            }
                        }, icon: {
                            Image(systemName: flag.symbol)
                        })
                        .foregroundStyle(flag.value ? .primary : .secondary)
                    })
                }
            }
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
        .overlay(
            PopupCloseOverlayButton()
        )
    }
}

#Preview {
    DebugSettingsView()
        .environmentObject(GlobalState())
}
