import SwiftUI

struct HeroExplainer: View {
    // NOTE: This is needed anywhere we want to listen for changes in the global state.
    @EnvironmentObject var globalState: GlobalState
    
    @State var title      : String = "Hero Title"
    @State var description: String = "This should descript what the page is about."
    @State var symbolName : String = "gear.circle.fill"
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: symbolName)
                .resizable().aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .padding(.bottom, 4)
            
            Text(title).font(.headline).bold()
            
            Text(description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
        .padding(.horizontal, 6) // TODO: this looks odd?
        .listRowBackground(is_feature_flag_enabled("NoHeroBackplate") ? Color.clear : Color.secondarySystemBackground)
    }
}

#Preview {
    List {
        VStack { HeroExplainer() }
    }
}
