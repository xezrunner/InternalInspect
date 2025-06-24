// InternalInspect::SearchTabState.swift - 24.06.2025

import Foundation

struct DomainFeatures: Identifiable {
    let id: String // Using domain as the unique identifier
    let features: [String]
}

@Observable class SearchTabState {
    var domains: FeatureFlagsDictionary = [:]
    var isProgress = false

    init() {
        reloadDictionary()
    }

    func reloadDictionary() {
        isProgress = true
        Task {
            let systemDict = FeatureFlagsSupport._getAllFFWithStates()
            let merged = FeatureFlagsSupport.mergedWithUserTrackedFeatures(base: systemDict)
            domains = merged
            isProgress = false
        }
    }

    func filteredDomains(searchQuery: String) -> [DomainFeatures] {
        let query = searchQuery.lowercased()
        let allDomains = Array(domains)
        var result: [DomainFeatures] = []
        for (domain, featuresDict) in allDomains {
            let featureNames = featuresDict.keys.sorted()
            if query.isEmpty {
                result.append(DomainFeatures(id: domain, features: featureNames))
                continue
            }
            if domain.lowercased().contains(query) {
                result.append(DomainFeatures(id: domain, features: featureNames))
            } else {
                let matches = featureNames.filter { $0.lowercased().contains(query) }
                if !matches.isEmpty {
                    result.append(DomainFeatures(id: domain, features: matches))
                }
            }
        }
        return result.sorted { $0.id < $1.id }
    }
}
