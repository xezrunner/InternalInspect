//
//  FeatureFlagsTabView.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

struct FeatureFlagsTab: View {
    @Environment(FeatureFlagsTabState.self) var state
    
    @State var selectedDomain: String?
    
    @State var domainsSearchQuery:  String = ""
    @State var featuresSearchQuery: String = ""
    
    var body: some View {
        VStack {
            if state.isProgress { progressView }
            else                { mainView }
        }
//        .task {
//            withAnimation(.linear(duration: 0.3)) {
//                state.reloadDictionary()
//            }
//        }
    }
    
    var mainView: some View {
        @Bindable var state = state
        
        return NavigationSplitView(preferredCompactColumn: .constant(NavigationSplitViewColumn.sidebar)) {
            let filtered = state.filteredDomains(query: domainsSearchQuery)
            
            List(filtered, id: \.key, selection: $selectedDomain) { domain, features in
                FeatureFlagDomainEntryView(domain: domain, features: features)
            }
            .searchable(text: $domainsSearchQuery, placement: .sidebar)
            .toolbar(removing: .sidebarToggle)
            .navigationSplitViewColumnWidth(min: 250, ideal: 300)
        } detail: {
            let filtered = state.filteredFeatures(domain: selectedDomain, query: featuresSearchQuery)
            
            if !filtered.isEmpty {
                List(filtered, id: \.key) { feature, result in
                    FeatureFlagFeatureEntryView(feature: feature, result: result)
                }
//                .safeAreaInset(edge: .top) {
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                        TextField("Search features", text: $featuresSearchQuery, prompt: Text("Search features..."))
//                            .textFieldStyle(.plain)
//                    }
//                    .padding(6)
//                    .background {
//                        Capsule().fill(.ultraThinMaterial)
//                    }
//                    .padding(.horizontal)
//                }
                .searchable(text: $featuresSearchQuery, placement: .toolbarPrincipal)
            } else {
                noFeaturesView
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    var progressView: some View {
        VStack(spacing: 8) {
            ProgressView()
                .progressViewStyle(.circular)
                .padding(.horizontal, 48)
            
            Text("Loading feature flags...").bold()
        }
        .transition(.opacity)
    }
    
    var noFeaturesView: some View {
        VStack(spacing: 6) {
            Image(systemName: "minus.diamond")
                .font(.system(size: 72))
            
            Text("This domain has no registered features.")
                .font(.title2)
        }
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
    @Environment(FeatureFlagsTabState.self) var state
    
    @State var feature: String
    @State var result: FeatureFlagState
    
    @State var isProgress = false
    
    var body: some View {
        Button {
            isProgress = true
            Task {
                toggleFeature(domainName: result.domain, featureName: feature)
                isProgress = false
            }
        } label: {
            featureEntryLabel
        }
        .disabled(isProgress)
    }
    
    func toggleFeature(domainName: String, featureName: String) {
        FeatureFlagsSupport.setFeature(newState: !result.isEnabled(), domain: domainName, feature: featureName)
        
        guard let domain = state.domains[domainName] else { return }
        guard domain[featureName] != nil else { return }
        let response = FeatureFlagsSupport.getFeature(domain: domainName, feature: featureName)
        
        state.domains[domainName]![featureName] = response
        result = response
    }
    
    var featureEntryLabel: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(feature).bold()
                
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Text("domain: "); Text(result.domain).bold()
                    }
                    
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
            
            if isProgress {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(0.65)
            }
            
            Circle()
                .fill(result.isEnabled() ? .green : .red)
                .frame(height: 16)
                .aspectRatio(1, contentMode: .fit)
        }
        .padding(4)
    }
}

