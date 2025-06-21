// InternalTest::FeatureFlagsTabViewState.swift - 22.06.2025

import Foundation

@Observable class FeatureFlagsTabState {
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
