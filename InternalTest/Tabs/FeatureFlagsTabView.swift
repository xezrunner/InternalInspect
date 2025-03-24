//
//  FeatureFlagsTabView.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

@Observable class FeatureFlagsTabViewGlobalState {
    var dictionary: FeatureFlagsDictionary
    
    var selectedDomain: String?
    
    init() {
        dictionary = FeatureFlagsSupport.getAllFF()
    }
    
    // TODO: duplicate:
    func reloadDictionary() {
        dictionary = FeatureFlagsSupport.getAllFF()
    }
}

struct FeatureFlagDomainEntryView: View {
    @State var domain: String
    @State var features: FeatureFlags_FeaturesDictionary
    
    var body: some View {
        NavigationLink(value: domain, label: {
            HStack {
                Text(domain)
                Spacer()
                Text("\(features.count)").font(.footnote)
            }
        })
    }
}

struct FeatureFlagFeatureEntryView: View {
    @State var feature: String
    @State var result: FeatureFlagState
    
    var body: some View {
        Button(action: {
            FeatureFlagsSupport.setFeature(newState: !result.isEnabled(), domain: result.domain, feature: feature)
        }) {
//        NavigationLink(value: feature, label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(feature).bold()
                    
                    Group {
                        Text("domain: ") + Text(result.domain).bold()
                    }
                    .font(.callout)
                    
                    Group {
                        Text("value: ") +
                        Text(String(describing: result.value)).bold()
                        
                        if result.isNotDeclared {
                            Text("This feature flag is not declared in the system, so it defaults to being off.")
                        }
                        
                        if !result.phase.isEmpty {
                            Text("phase: ") +
                            Text(result.phase).bold()
                        }
                        
                        if !result.disclosureRequired.isEmpty {
                            Text("disclosure required: ") +
                            Text(result.disclosureRequired).bold()
                        }
                    }
                    .font(.subheadline)
                    .monospaced()
                }
                Spacer()
                Circle()
                    .fill(result.isEnabled() ? .green : .red)
                    .frame(height: 16)
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct FeatureFlagsTabView: View {
    @Environment(GlobalState2.self) var globalState: GlobalState2
    
    @State var domainsSearchQuery:  String = ""
    @State var featuresSearchQuery: String = ""
    
    var body: some View {
        @Bindable var globalState = globalState
        let domains = globalState.featureFlagsTabViewState.dictionary
        let domainsArray = Array(domains)
            .sorted { $0.key < $1.key }
            .filter { entry in
                domainsSearchQuery.isEmpty ? true : entry.key.lowercased().contains(domainsSearchQuery.lowercased())
            }
        
        NavigationSplitView {
            List(domainsArray, id: \.key, selection: $globalState.featureFlagsTabViewState.selectedDomain) { domain, features in
                FeatureFlagDomainEntryView(domain: domain, features: features)
            }
            .searchable(text: $domainsSearchQuery, placement: .sidebar)
            .toolbar(removing: .sidebarToggle)
        } detail: {
            if let selectedDomain = globalState.featureFlagsTabViewState.selectedDomain {
                if let features = domains[selectedDomain] {
                    let featuresArray = Array(features)
                        .sorted { $0.key < $1.key }
                        .filter { entry in
                            featuresSearchQuery.isEmpty ? true : entry.key.lowercased().contains(featuresSearchQuery.lowercased())
                        }
                    
                    List(featuresArray, id: \.key) { feature, result in
                        FeatureFlagFeatureEntryView(feature: feature, result: result)
                    }
                    .searchable(text: $featuresSearchQuery)
                }
            }
        }
        .id(globalState.featureFlagsTabViewState.dictionary.hashValue)
    }
}
