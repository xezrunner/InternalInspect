import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            if #available(iOS 17.0, *) {
                List(packetGroups) { group in
                    PacketGroupSectionView(group)
                }
                .listSectionSpacing(.compact)
                .navigationTitle("Internal states")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: {
                            alertMessage("Info", "This application lists functions that report internal statuses. They are called and their results are presented.")
                        }, label: {
                            Label("Internal states", systemImage: "info.circle")
                        })
                    })
                }
                /*
                .safeAreaInset(edge: .top) {
                    HStack {
                        Spacer()
                        
                        Spacer()
                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                }
                */
            }
            
        }
    }
    
}

func alertMessage(_ title: String, _ message: String) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
    }
    alertVC.addAction(okAction)

    let viewController = UIApplication.shared.windows.first!.rootViewController!
    viewController.present(alertVC, animated: true, completion: nil)
}

#Preview {
    ContentView()
}

