//
//  FeatureFlagsTabView.swift
//  InternalInspect
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

struct FeatureFlagsTab: View {
    @Environment(FeatureFlagsTabState.self) var state
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isPhoneIdiom: Bool { horizontalSizeClass == .compact }
    
    @State var selectedDomain: String?
    
    @State var domainsSearchQuery:  String = ""
    @State var featuresSearchQuery: String = ""
    
    @State var searchQuery: String = ""
    
    @State var isPresentingAddFeatureSheet = false
    
    var body: some View {
        VStack {
            if state.isProgress { progressView }
            else                { mainView }
        }
        .animation(.linear, value: state.isProgress)
    }
    
    var mainView: some View {
        @Bindable var state = state
        
        return NavigationSplitView {
            domainsSidebar
                .task { state.reloadDictionary() }
                .navigationTitle("Domains")
        } detail: {
            let filtered = state.filteredFeatures(domain: selectedDomain, query: searchQuery)
            
            let view = Group {
                if !filtered.isEmpty {
                    featuresDetail(filtered: filtered)
                } else if selectedDomain != nil {
                    noFeaturesView
                } else {
                    noDomainSelectedView
                }
            }
            .navigationTitle(selectedDomain ?? "Features")
            .toolbar { toolbar }
            
            if isPhoneIdiom { view.searchable(text: $searchQuery) } else { view }
        }
        .navigationSplitViewStyle(.balanced)
        
        .searchable(text: $searchQuery)
        
        .sheet(isPresented: $isPresentingAddFeatureSheet) {
            FeatureFlagAddCustomEntrySheetView(isSheetPresented: $isPresentingAddFeatureSheet, domainText: selectedDomain ?? "")
                .overlay { PopupCloseOverlayButton() }
            
                .presentationDetents([.medium])
            
                .environment(state)
        }
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItem(id: "add-feature", placement: .primaryAction) {
            Button("Add feature", systemImage: "plus") { isPresentingAddFeatureSheet = true }
        }
    }
    
    var domainsSidebar: some View {
        let filtered = state.filteredDomains(query: searchQuery)
        
        return List(filtered, id: \.key, selection: $selectedDomain) { domain, features in
            FeatureFlagDomainEntryView(domain: domain, features: features)
        }
        .refreshable { state.reloadDictionary() }
        
        .toolbar(removing: .sidebarToggle)
        .toolbar { if isPhoneIdiom { toolbar } }
        
        .navigationSplitViewColumnWidth(min: 250, ideal: 300)
    }
    
    func featuresDetail(filtered: [(key: String, value: FeatureFlagState)]) -> some View {
        List(filtered, id: \.key) { feature, result in
            FeatureFlagFeatureEntryView(featureName: feature, featureState: result)
                .id(result.hashValue)
        }
        .refreshable { await refreshFeatures(filtered: filtered) }
        
        .scrollContentBackground(.hidden)
        .listRowBackground(Color.clear)
    }
    
    private func refreshFeatures(filtered: [(key: String, value: FeatureFlagState)]) async {
        for (feature, currentState) in filtered {
            let response = FeatureFlagsSupport.getFeature(domain: currentState.domain, feature: feature)
            
            if state.domains[currentState.domain]?[feature] != nil {
                state.domains[currentState.domain]![feature] = response
            } else {
                print("pull-to-refresh: filtered features had \(selectedDomain ?? "nil")::\(feature), but it isn't in domains!");
            }
        }
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
            
            Text("This domain has no registered features")
                .font(.title2)
        }
    }
    
    var noDomainSelectedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "pointer.arrow.rays")
                .font(.system(size: 72))
            
            Text("Select a domain to see its features")
                .font(.title2)
        }
    }
}
