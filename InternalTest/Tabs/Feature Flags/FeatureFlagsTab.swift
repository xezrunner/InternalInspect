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
    
    @State var isPresentingAddFeatureSheet = false
    
    var body: some View {
        VStack {
            if state.isProgress { progressView }
            else                { mainView }
        }
        .task {
            withAnimation(.linear(duration: 0.3)) {
                state.reloadDictionary()
            }
        }
    }
    
    var mainView: some View {
        @Bindable var state = state
        
        return NavigationSplitView(preferredCompactColumn: .constant(NavigationSplitViewColumn.sidebar)) {
            domainsSidebar
        } detail: {
            let filtered = state.filteredFeatures(domain: selectedDomain, query: featuresSearchQuery)
            
            Group {
                if !filtered.isEmpty {
                    featuresDetail(filtered: filtered)
                } else if selectedDomain != nil {
                    noFeaturesView
                } else {
                    noDomainSelectedView
                }
            }
            .toolbar {
                ToolbarItem(id: "add-feature", placement: .primaryAction) {
                    Button("Add feature", systemImage: "plus") { isPresentingAddFeatureSheet = true }
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $isPresentingAddFeatureSheet) {
            AddUserTrackedFeatureSheetView(isSheetPresented: $isPresentingAddFeatureSheet)
                .overlay { PopupCloseOverlayButton() }
                .environment(state)
        }
    }
    
    var domainsSidebar: some View {
        let filtered = state.filteredDomains(query: domainsSearchQuery)
        
        return List(filtered, id: \.key, selection: $selectedDomain) { domain, features in
            FeatureFlagDomainEntryView(domain: domain, features: features)
        }
        .searchable(text: $domainsSearchQuery, placement: .sidebar)
        .toolbar(removing: .sidebarToggle)
        .navigationSplitViewColumnWidth(min: 250, ideal: 300)
        .id(state.domains.hashValue)
    }
    
    func featuresDetail(filtered: [(key: String, value: FeatureFlagState)]) -> some View {
        List(filtered, id: \.key) { feature, result in
            FeatureFlagFeatureEntryView(featureName: feature, featureState: result)
        }
        .searchable(text: $featuresSearchQuery, placement: .toolbarPrincipal)
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
        VStack(spacing: 16) {
            Image(systemName: "minus.diamond")
                .font(.system(size: 72))
            
            Text("This domain has no registered features.")
                .font(.title2)
        }
    }
    
    var noDomainSelectedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "pointer.arrow.rays")
                .font(.system(size: 72))
            
            Text("Select a domain to see its features.")
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
