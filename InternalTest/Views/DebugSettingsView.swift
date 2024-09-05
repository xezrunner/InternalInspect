import SwiftUI

struct DebugSettingsView: View {
    @EnvironmentObject var globalState: GlobalState
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
        .environmentObject(GlobalState())
}
