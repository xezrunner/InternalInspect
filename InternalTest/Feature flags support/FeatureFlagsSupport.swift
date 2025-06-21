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
    
    public static func getFeature(domain: String, feature: String) -> FeatureFlagState {
        return FeatureFlagsBridge.getValue(domain, feature)
    }
    
    public static func setFeature(newState: Bool, domain: String, feature: String) {
        FeatureFlagsBridge.setFeature(newState, domain, feature)
    }
    
    
}
