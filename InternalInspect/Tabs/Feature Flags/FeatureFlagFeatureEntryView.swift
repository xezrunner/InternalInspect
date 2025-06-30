// InternalInspect::FeatureFlagFeatureEntryView.swift - 24.06.2025
import SwiftUI

struct FeatureFlagFeatureEntryView: View {
    @Environment(FeatureFlagsTabState.self) var state
    
    @State var featureName:  String // TODO: is this needed if we already have it in featureState?
    @State var featureState: FeatureFlagState
    
    @State var isProgress = false
    
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
            deleteButton
        }
        .contextMenu {
            deleteButton
        }
    }
    
    var deleteButton: some View {
        Button(role: featureState.isNotSystemDeclared ? .destructive : nil) {
            deleteFeature()
        } label: {
            Label(featureState.isNotSystemDeclared ? "Delete" : "Unset",
                  systemImage: featureState.isNotSystemDeclared ? "trash" : "xmark.circle")
        }
    }
    
    func deleteFeature() {
        if featureState.isNotSystemDeclared {
            if var domainFeatures = state.domains[featureState.domain] {
                domainFeatures.removeValue(forKey: featureName)
                state.domains[featureState.domain] = domainFeatures
            }
            FeatureFlagsSupport.deleteUserAddedFeature(domain: featureState.domain, feature: featureName)
        } else {
            FeatureFlagsSupport.unsetFeature(domain: featureState.domain, feature: featureName)
            featureState = FeatureFlagsSupport.refreshFeatureState(state: featureState)
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
                Text(featureName)
                    .bold(featureState.isEnabled())
                
                Group {
//                    HStack(spacing: 0) {
//                        Text("domain: ")
//                        Text(featureState.domain)
//                            .bold(featureState.isEnabled())
//                    }
                    
                    HStack(spacing: 0) {
                        Text("value: ")
                        Text("\(featureState.value) (\(featureState.value == 0 ? "disabled" : "enabled"))")
                            .bold(featureState.isEnabled())
                    }
                }
                
                if featureState.isNotSystemDeclared {
                    Text("This feature flag is not declared in the system, so it defaults to being off.")
                }
                
                if featureState.isAddedByUser {
                    Text("This feature flag was added by you.")
                }
                
                if !featureState.phase.isEmpty {
                    HStack(spacing: 0) {
                        Text("phase: "); Text(featureState.phase).bold(featureState.isEnabled())
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
            .opacity(featureState.isEnabled() ? 1 : 0.7)
            
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
        .tint(.primary)
    }
}

