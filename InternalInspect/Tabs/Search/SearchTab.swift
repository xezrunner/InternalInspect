//
//  SearchTab.swift
//  InternalInspect
//
//  Created by AI Assistant on 24/06/2025.
//

import SwiftUI

struct SearchTab: View {
    @Environment(SearchTabState.self) var state
    
    @State var featureFlagsTabState = FeatureFlagsTabState()
    
    @Binding var searchQuery: String
    @State private var expandedDomains: Set<String> = []
    
    var body: some View {
        let domains = state.filteredDomains(searchQuery: searchQuery)
        
        NavigationStack {
            Form {
                Section("Feature Flags") {
                    List(domains) { domainFeatures in
                        DisclosureGroup(isExpanded: Binding(
                            get: { expandedDomains.contains(domainFeatures.id) },
                            set: { isOpen in
                                if isOpen { expandedDomains.insert(domainFeatures.id) }
                                else { expandedDomains.remove(domainFeatures.id) }
                            })
                        ) {
                            ForEach(domainFeatures.features, id: \.self) { feature in
                                SearchFeatureRow(domain: domainFeatures.id, feature: feature)
                            }
                        } label: {
                            Label {
                                HStack {
                                    Text(domainFeatures.id)
                                    Spacer()
                                    Text("\(domainFeatures.features.count)")
                                        .foregroundStyle(.secondary).font(.callout)
                                }
                            } icon: {
                                EmptyView()
                            }
                            .labelStyle(.titleOnly)
                        }
                    }
                }
            }
            
            .overlay {
                if state.isProgress {
                    VStack(spacing: 8) {
                        ProgressView().progressViewStyle(.circular).padding(.horizontal, 48)
                        Text("Loading feature flags...").bold()
                    }
                }
            }
            
            .id(state.domains.hashValue)
            
            .environment(featureFlagsTabState)
        }
    }
}

struct SearchFeatureRow: View {
    @Environment(FeatureFlagsTabState.self) var featureFlagsTabstate
    @Environment(SearchTabState.self) var state
    
    let domain: String
    let feature: String
    var body: some View {
        let featureState = FeatureFlagsSupport.getFeature(domain: domain, feature: feature)
        FeatureFlagFeatureEntryView(featureName: feature, featureState: featureState)
    }
}
