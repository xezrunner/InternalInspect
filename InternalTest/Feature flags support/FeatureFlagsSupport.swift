//
//  FeatureFlagsSupport.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

public typealias FeatureFlagsDictionary = [String: FeatureFlags_FeaturesDictionary]
public typealias FeatureFlags_FeaturesDictionary = [String: FeatureFlagState]

class FeatureFlagsSupport {
    public static func getAllSystemFF() -> [String: Set<String>] {
        var all: [String: Set<String>] = [:]
        let domains = FeatureFlagsBridge.getDomains() as? Set<String> ?? []
        for domain in domains {
            let features = FeatureFlagsBridge.getFeaturesForDomain(domain) as? Set<String> ?? []
            all[domain] = features
        }
        return all
    }
    
    public static func _getAllFFWithStates() -> FeatureFlagsDictionary {
        var all: FeatureFlagsDictionary = [:]
        
        let domains = FeatureFlagsBridge.getDomains() as? Set<String> ?? []
        for domain in domains {
            all[domain] = [:]
            
            let features = FeatureFlagsBridge.getFeaturesForDomain(domain) as? Set<String> ?? []
            
            for feature in features {
                all[domain]?[feature] = FeatureFlagsBridge.getValue(domain, feature)
            }
        }
        
        return all
    }
    
    public static func mergedWithUserTrackedFeatures(base: FeatureFlagsDictionary) -> FeatureFlagsDictionary {
        let userTrackedFeaturesKey = "UserTrackedFeatures"
        guard let userTracked = UserDefaults.standard.array(forKey: userTrackedFeaturesKey) as? [[String: String]] else {
            return base
        }
        
        var merged = base
        for entry in userTracked {
            guard let domain = entry["domain"], let feature = entry["feature"] else { continue }
            var domainFeatures = merged[domain] ?? [:]
            // Only add if not already present
            if domainFeatures[feature] == nil {
                let state = FeatureFlagsBridge.getValue(domain, feature)
                state.isAddedByUser = true
                domainFeatures[feature] = state
                merged[domain] = domainFeatures
            }
        }
        return merged
    }
    
    public static func getFeature(domain: String, feature: String) -> FeatureFlagState {
        return FeatureFlagsBridge.getValue(domain, feature)
    }
    
    public static func setFeature(newState: Bool, domain: String, feature: String) {
        FeatureFlagsBridge.setFeature(newState, domain, feature)
    }
    
    public static func deleteUserAdded(domain: String) {
        let userTrackedFeaturesKey = "UserTrackedFeatures"
        var array = UserDefaults.standard.array(forKey: userTrackedFeaturesKey) as? [[String: String]] ?? []
        
        array.removeAll { $0["domain"] == domain }
        UserDefaults.standard.set(array, forKey: userTrackedFeaturesKey)
    }
    
    public static func deleteUserAddedFeature(domain: String, feature: String) {
        let userTrackedFeaturesKey = "UserTrackedFeatures"
        var array = UserDefaults.standard.array(forKey: userTrackedFeaturesKey) as? [[String: String]] ?? []
        
        if let idx = array.firstIndex(where: { $0["domain"] == domain && $0["feature"] == feature }) {
            array.remove(at: idx)
            UserDefaults.standard.set(array, forKey: userTrackedFeaturesKey)
        } else {
            print("Feature \(feature) not in UserDefaults!")
        }
    }
}
