import SwiftUI

struct PopupCloseOverlayButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
#if os(iOS)
        let idiom = UIDevice.current.userInterfaceIdiom
        let processInfo = ProcessInfo.processInfo
        
        let shouldShowDismissButton = idiom != .phone && (idiom == .pad && processInfo.isiOSAppOnMac)
#else
        let shouldShowDismissButton = true
#endif
        if !shouldShowDismissButton { EmptyView() }
        else {
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
        }
    }
}
