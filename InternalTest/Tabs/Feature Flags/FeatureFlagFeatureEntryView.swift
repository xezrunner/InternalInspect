// InternalTest::FeatureFlagFeatureEntryView.swift - 24.06.2025
import SwiftUI

struct FeatureFlagFeatureEntryView: View {
    @Environment(FeatureFlagsTabState.self) var state
    
    @State var featureName:  String
    @State var featureState: FeatureFlagState
    
    @State var isProgress = false
    
    func deleteFeature() {
        let userTrackedFeaturesKey = "UserTrackedFeatures"
        var array = UserDefaults.standard.array(forKey: userTrackedFeaturesKey) as? [[String: String]] ?? []
        
        if let idx = array.firstIndex(where: { $0["domain"] == featureState.domain && $0["feature"] == featureName }) {
            array.remove(at: idx)
            UserDefaults.standard.set(array, forKey: userTrackedFeaturesKey)
            state.reloadDictionary()
        } else {
            print("Feature \(featureName) not in UserDefaults!")
        }
    }
    
    var body: some View {
        Group {
            Button {
                isProgress = true
                Task {
                    toggleFeature(domainName: featureState.domain, featureName: featureName)
                    isProgress = false
                }
            } label: {
                featureEntryLabel
            }
            .disabled(isProgress)
        }
        
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if featureState.isAddedByUser {
                Button(role: .destructive) {
                    deleteFeature()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .contextMenu {
            Button(role: .destructive) {
                deleteFeature()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .disabled(!featureState.isAddedByUser)
        }
    }
    
    func toggleFeature(domainName: String, featureName: String) {
        FeatureFlagsSupport.setFeature(newState: !featureState.isEnabled(), domain: domainName, feature: featureName)
        
        guard let domain = state.domains[domainName] else { return }
        guard domain[featureName] != nil else { return }
        let response = FeatureFlagsSupport.getFeature(domain: domainName, feature: featureName)
        
        state.domains[domainName]![featureName] = response
        featureState = response
    }
    
    var featureEntryLabel: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(featureName).bold()
                
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Text("domain: "); Text(featureState.domain).bold()
                    }
                    
                    HStack(spacing: 0) {
                        Text("value: "); Text("\(featureState.value) (\(featureState.value == 0 ? "disabled" : "enabled"))").bold()
                    }
                    
                    if featureState.isNotSystemDeclared {
                        Text("This feature flag is not declared in the system, so it defaults to being off.")
                    }
                    
                    if featureState.isAddedByUser {
                        Text("This feature flag was added by you.")
                    }
                    
                    if !featureState.phase.isEmpty {
                        HStack(spacing: 0) {
                            Text("phase: "); Text(featureState.phase).bold()
                        }
                    }
                    
                    if !featureState.disclosureRequired.isEmpty {
                        HStack(spacing: 0) {
                            Text("disclosure required: "); Text(featureState.disclosureRequired).monospaced()
                        }
                    }
                }
                .font(.subheadline)
                .monospaced()
            }
            
            Spacer()
            
            if isProgress {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(0.65)
            }
            
            Circle()
                .fill(featureState.isEnabled() ? .green : .red)
                .frame(height: 16)
                .aspectRatio(1, contentMode: .fit)
        }
        .padding(4)
    }
}

