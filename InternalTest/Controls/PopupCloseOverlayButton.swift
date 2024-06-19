import SwiftUI

struct PopupCloseOverlayButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
#if os(visionOS) || targetEnvironment(macCatalyst)
        HStack {
            Spacer()
            Button(action: { dismiss() }, label: {
                Label("Dismiss", systemImage: "xmark").labelStyle(.iconOnly)
                    .padding(2)
            })
            .foregroundStyle(.primary)
            .buttonStyle(BorderedButtonStyle())
            .buttonBorderShape(.circle)
            .listRowSeparator(.hidden)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(24)
#endif
    }
}
