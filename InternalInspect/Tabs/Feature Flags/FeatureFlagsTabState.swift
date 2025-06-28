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
    
    // withFeatures: whether to include those domains that have feature names containing the query
    func filteredDomains(query: String, withFeatures: Bool = true) -> [(key: String, value: FeatureFlags_FeaturesDictionary)] {
        let query = query.lowercased()
        var allDomains = domains
        
        if query.isEmpty {
            return allDomains.sorted { $0.key < $1.key }
        }
        
        // 1. Filter the features inside the domains:
        allDomains.forEach { (domain: String, features: FeatureFlags_FeaturesDictionary) in
            allDomains[domain] = features.filter({ (featureName: String, _) in
                featureName.lowercased().contains(query)
            })
        }
        // 2. Match for domain names:
        allDomains = allDomains.filter({ (domainName: String, features: FeatureFlags_FeaturesDictionary) in
            // If there are any features filtered out from above and withFeatures is requested, we want the domain.
            // Otherwise, only if the domain name contains the query.
            (withFeatures && features.count > 0) ? true : domainName.lowercased().contains(query)
        })
        
        // 3. Sort
        // If features are included, sort by feature count. Otherwise, sort alphabetically.
        let sorted = allDomains.sorted {
            if withFeatures {
                if $0.value.count == $1.value.count { return $0.key < $1.key }
                return $0.value.count > $1.value.count
            }
            
            return $0.key < $1.key
        }
        
        return sorted
    }
    
    func filteredFeatures(domain: String?, query: String) -> [(key: String, value: FeatureFlagState)] {
        guard let selectedDomain = domain,
              let features = domains[selectedDomain] else { return [] }
        return features.filter { key, _ in
            query.isEmpty || key.lowercased().contains(query.lowercased())
        }.sorted { $0.key < $1.key }
    }
}

