//
//  FeatureFlagsSupport.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

public typealias FeatureFlagsDictionary = [String: FeatureFlags_FeaturesDictionary]
public typealias FeatureFlags_FeaturesDictionary = [String: FeatureFlagState]

class FeatureFlagsSupport {
    
    public static func getAllFF() -> FeatureFlagsDictionary {
        var all: FeatureFlagsDictionary = [:]
        
        let domains = FeatureFlagsBridge.getDomains() as? Set<String> ?? []
        for domain in domains {
            all[domain] = [:]
            
            var features = FeatureFlagsBridge.getFeaturesForDomain(domain) as? Set<String> ?? []
            if domain == "Siri" { // TEMP: @CustomFeatureFlags
                features.insert("sae")
                features.insert("sae_override")
            }
            
            for feature in features {
                all[domain]?[feature] = FeatureFlagsBridge.getValue(domain, feature)
            }
        }
        
        return all
    }
    
    
}
