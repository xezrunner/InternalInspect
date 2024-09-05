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

class GlobalFeatureFlags: ObservableObject {
    @Published var consoleLines: [(String, String)] = []
    
    @Published var flags: [FeatureFlag] = [
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
    
    public func getBool(name: String) -> Bool {
        let result = flags.first(where: { (flagName) -> Bool in
            return flagName.name == name})?.value
        if result != nil { return result! }
        return false
    }
    
    public func addConsoleLine(text: (String, String)) {
        consoleLines.append(text)
    }
}

struct DebugSettingsView: View {
    @EnvironmentObject var featureFlags: GlobalFeatureFlags
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            VStack(alignment: .center) {
                Image(systemName: "ant.circle.fill")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .padding(.bottom, 2)
                
                Text("Debug settings").font(.headline).bold()
                Text("If you're reading this, you are violating the terms and conditions of this app.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
            }
            .padding(.vertical)
            .padding(.horizontal, 8)
            .listRowBackground(Color.clear)
            
            Section("Feature flags") {
                ForEach(0 ..< featureFlags.flags.count, id: \.self) { index in
                    let flag      =  featureFlags.flags[index]
                    let flagValue = $featureFlags.flags[index].value
                    
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
            ZStack {
                PopupCloseOverlayButton()
                Text("TRANSIENT")
                    .font(.footnote).textCase(.uppercase)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .opacity(0.3)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.vertical, 75)
                    .padding(.horizontal, 24)
            }
        )
    }
}

#Preview {
    DebugSettingsView()
        .environmentObject(GlobalFeatureFlags())
}
