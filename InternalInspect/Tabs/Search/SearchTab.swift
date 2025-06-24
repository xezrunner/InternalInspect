// InternalInspect::SearchTab.swift - 24.06.2025
import SwiftUI

struct SearchTab: View {
    @Environment(SearchTabState.self) var state
    
    @State var featureFlagsTabState = FeatureFlagsTabState()
    
    @Binding var searchQuery: String
    @State private var expandedDomains: Set<String> = []
    
    var body: some View {
        NavigationStack {
            Form {
                featureFlagsSection
                    .environment(featureFlagsTabState)
                    .task { featureFlagsTabState.reloadDictionary() }
            }
        }
    }
    
    func featureFlagsDisclosureGroupBinding(domainName: String) -> Binding<Bool> {
        Binding {
            expandedDomains.contains(domainName)
        } set: { isOpen in
            if isOpen { expandedDomains.insert(domainName) }
            else      { expandedDomains.remove(domainName) }
        }

    }
    
    var featureFlagsSection: some View {
        let domains = featureFlagsTabState.filteredDomains(query: searchQuery)
        
        return Section("Feature Flags") {
            List(domains, id: \.key) { domain, features in
                let featuresArray = featureFlagsTabState.filteredFeatures(domain: domain, query: searchQuery)
                DisclosureGroup {
                    ForEach(featuresArray, id: \.key) { feature, state in
                        FeatureFlagFeatureEntryView(featureName: feature, featureState: state)
                    }
                } label: {
                    HStack {
                        Text(domain)
                        Spacer()
                        Text("\(featuresArray.count)")
                    }
                }
            }
        }
    }
}

struct SearchFeatureRow: View {
    @Environment(FeatureFlagsTabState.self) var featureFlagsTabstate
    @Environment(SearchTabState.self) var state
    
    let domain: String
    @State var featureState: FeatureFlagState
    
    var body: some View {
        FeatureFlagFeatureEntryView(featureName: featureState.feature, featureState: featureState)
            .id(featureState.hashValue)
    }
}
