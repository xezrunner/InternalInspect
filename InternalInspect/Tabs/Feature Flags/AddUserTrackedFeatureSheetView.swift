// InternalInspect::AddUserTrackedFeatureSheetView.swift - 23.06.2025
import SwiftUI

struct AddUserTrackedFeatureSheetView: View {
    @Environment(FeatureFlagsTabState.self) var state
    
    @Binding var isSheetPresented: Bool
    
    @State var domainText:  String = ""
    @State var featureText: String = ""
    
    @State var error: String?
    
    var body: some View {
        VStack(spacing: 24) {
            HeroExplainer(title: "Add new feature",
                          description: "This domain and feature will be tracked by the application in addition to system feature flags.",
                          symbolName: "gear")
            
            VStack {
                TextField("Domain",  text: $domainText,  prompt: Text("Domain name"))
                TextField("Feature", text: $featureText, prompt: Text("Feature name"))
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            
            if error != nil { Text(error!).foregroundStyle(.orange) }
            
            Button("Add feature", action: performAdd)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    func performAdd() {
        guard !domainText.trimmingCharacters(in: .whitespaces).isEmpty,
              !featureText.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "Type a domain and feature name."; return
        }
        
        let userTrackedFeaturesKey = "UserTrackedFeatures"
        
        var array = UserDefaults.standard.array(forKey: userTrackedFeaturesKey) as? [[String: String]] ?? []
        let newEntry = ["domain": domainText, "feature": featureText]
        
        if array.contains(where: { $0["domain"] == domainText && $0["feature"] == featureText }) {
            error = "This feature is already being tracked."; return
        }
        
        // Store:
        array.append(newEntry)
        UserDefaults.standard.set(array, forKey: userTrackedFeaturesKey)
        
        state.reloadDictionary()
        
        isSheetPresented = false
    }
}
