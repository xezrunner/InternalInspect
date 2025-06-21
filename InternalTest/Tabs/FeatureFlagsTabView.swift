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
        dictionary = FeatureFlagsSupport._getAllFFWithStates()
    }
    
    // TODO: duplicate:
    func reloadDictionary() {
        dictionary = FeatureFlagsSupport._getAllFFWithStates()
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
    @Environment(GlobalState2.self) var globalState: GlobalState2
    
    @State var feature: String
    @State var result: FeatureFlagState
    
    var body: some View {
        Button {
            toggleFeature(domainName: result.domain, featureName: feature)
        } label: {
            featureEntryLabel
        }
    }
    
    func toggleFeature(domainName: String, featureName: String) {
        FeatureFlagsSupport.setFeature(newState: !result.isEnabled(), domain: domainName, feature: featureName)
        
        guard let domain = globalState.featureFlagsTabViewState.dictionary[domainName] else { return }
        guard domain[featureName] != nil else { return }
        let response = FeatureFlagsSupport.getFeature(domain: domainName, feature: featureName)
        
        globalState.featureFlagsTabViewState.dictionary[domainName]![featureName] = response
    }
    
    var featureEntryLabel: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(feature).bold()
                
                HStack(spacing: 0) {
                    Text("domain: "); Text(result.domain).bold()
                }
                .font(.callout)
                
                VStack {
                    HStack(spacing: 0) {
                        Text("value: "); Text("\(result.value) (\(result.value == 0 ? "disabled" : "enabled"))").bold()
                    }
                    
                    if result.isNotDeclared {
                        Text("This feature flag is not declared in the system, so it defaults to being off.")
                    }
                    
                    if !result.phase.isEmpty {
                        HStack(spacing: 0) {
                            Text("phase: "); Text(result.phase).bold()
                        }
                    }
                    
                    if !result.disclosureRequired.isEmpty {
                        HStack(spacing: 0) {
                            Text("disclosure required: "); Text(result.disclosureRequired).monospaced()
                        }
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
