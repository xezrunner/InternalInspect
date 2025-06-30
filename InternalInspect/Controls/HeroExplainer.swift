import SwiftUI

struct HeroExplainer: View {
    // NOTE: This is needed anywhere we want to listen for changes in the global state.
    @Environment(GlobalState.self) var globalState
    
    @State var title      : String
    @State var description: String
    @State var symbolName : String
    @State var tint       : Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: symbolName)
                .resizable().aspectRatio(contentMode: .fit)
                .foregroundStyle(.tint)
                .padding(.bottom, 4)
                .frame(width: 48, height: 48)
                .tint(tint)
            
            Text(title).font(.headline).bold()
            
            if !description.isEmpty {
                Text(description).font(.subheadline).multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 6) // TODO: this looks odd?
        .listRowBackground(Color.primary.opacity(0.08))
    }
    
    init(title: String, description: String, symbolName: String, tint: Color = .primary) {
        self.title = title
        self.description = description
        self.symbolName = symbolName
        self.tint = tint
    }
}

#Preview {
    List {
        VStack {
            HeroExplainer(title:       "Hero Title",
                          description: "This should descript what the page is about.",
                          symbolName:  "gear.circle.fill")
        }
    }
}
