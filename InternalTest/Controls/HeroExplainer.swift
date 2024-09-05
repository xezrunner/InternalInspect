import SwiftUI

struct HeroExplainer: View {
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
    }
}

#Preview {
    List() {
        VStack {
            HeroExplainer()
        }
    }
}
