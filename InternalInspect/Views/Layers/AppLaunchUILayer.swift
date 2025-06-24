import SwiftUI

func getAllApps() -> [String] {
    guard let obj = objc_getClass("LSApplicationWorkspace") as? NSObject else { return [] }
    let workspace = obj.perform(Selector(("defaultWorkspace")))?.takeUnretainedValue() as? NSObject
    let list = workspace?.perform(Selector(("allApplications")))?.takeUnretainedValue() as? Array<NSObject>
    let ids = list!.map { $0.value(forKey: "applicationIdentifier") as! String }
    return ids
}

func openApp(_ bundleID: String) -> Bool {
    guard let obj = objc_getClass("LSApplicationWorkspace") as? NSObject else { return false }
    let workspace = obj.perform(Selector(("defaultWorkspace")))?.takeUnretainedValue() as? NSObject
    let open = workspace?.perform(Selector(("openApplicationWithBundleID:")), with: bundleID) != nil
    return open
}

struct AppLaunchUILayer: View {
    @Environment(GlobalState.self) var globalState
    @Environment(\.colorScheme) var colorScheme
    
    @State private var input = ""
    
    var body: some View {
        @Bindable var globalState = globalState
        
        ZStack {}
            .sheet(isPresented: $globalState.showAppLaunch) {
                VStack {
#if targetEnvironment(simulator)
                    List(globalState.appLaunchList, id: \.self) { id in
                        Button(id) {
                            let result = openApp(id)
                            print("open app result for id \(id): \(result)")
                        }
                        .tint(.primary)
                    }
#else
                    TextField("app bundle identifier", text: $input).padding()
                        .textFieldStyle(.roundedBorder)
                    
                    Button("commit") {_ = openApp(input)}.buttonStyle(.bordered)
#endif
                }
                .padding()
                .overlay(PopupCloseOverlayButton())
                .presentationBackground(colorScheme == .light ? Color.white : Color.black)
#if targetEnvironment(simulator)
                .presentationDetents([.large])
#else
                .presentationDetents([.fraction(0.2)])
#endif
#if os(visionOS) || targetEnvironment(macCatalyst)
                .presentationDragIndicator(.hidden)
#endif
            }
    }
}

#Preview {
    var globalState = GlobalState()
    
    VStack {
        AppLaunchUILayer()
            .environment(globalState)
            .onAppear() {
                globalState.showAppLaunch = true
            }
    }
}
