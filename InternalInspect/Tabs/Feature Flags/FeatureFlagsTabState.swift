// InternalInspect::FeatureFlagsTabViewState.swift - 22.06.2025

import Foundation

@Observable class FeatureFlagsTabState {
    var domains: FeatureFlagsDictionary = [:]
    
    var isProgress = false
    
//    init() {
//        reloadDictionary()
//    }
    
    func reloadDictionary() {
        isProgress = true
        Task {
            let systemDict = FeatureFlagsSupport._getAllFFWithStates()
            let merged = FeatureFlagsSupport.mergedWithUserTrackedFeatures(base: systemDict)
            domains = merged
            
            isProgress = false
        }
    }
    
    func filteredDomains(query: String) -> [(key: String, value: FeatureFlags_FeaturesDictionary)] {
        let query = query.lowercased()
        let allDomains = Array(domains)
        
        // If the query is empty, sort alphabetically
        if query.isEmpty {
            return allDomains.sorted { $0.key < $1.key }
        }
        
        // Otherwise, score each entry by how many things match
        let scored = allDomains.compactMap { entry -> (score: Int, key: String, value: FeatureFlags_FeaturesDictionary)? in
            let keyMatch = entry.key.lowercased().contains(query) ? 1 : 0
            let featureMatches = entry.value.reduce(0) { acc, feature in
                acc + (feature.key.lowercased().contains(query) ? 1 : 0)
            }
            let score = keyMatch + featureMatches
            return score > 0 ? (score, entry.key, entry.value) : nil
        }
        
        return scored.sorted {
            if $0.score == $1.score {
                return $0.key < $1.key
            } else {
                return $0.score > $1.score
            }
        }.map { (key: $0.key, value: $0.value) }
    }
    
    func filteredFeatures(domain: String?, query: String) -> [(key: String, value: FeatureFlagState)] {
        guard let selectedDomain = domain,
              let features = domains[selectedDomain] else { return [] }
        return features.filter { key, _ in
            query.isEmpty || key.lowercased().contains(query.lowercased())
        }.sorted { $0.key < $1.key }
    }
}

