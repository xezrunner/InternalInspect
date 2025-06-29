import SwiftUI

internal protocol AppFeatureFlagProtocol: CaseIterable, Identifiable, Hashable, Equatable, RawRepresentable where AllCases == [Self], RawValue: StringProtocol {
    var id: Self { get }
    
    var description: String? { get }
    var symbol: String { get }
    
    var defaultValue: Bool { get }
}

@Observable internal class AppFeatureFlagOverrideSupport {
    static var shared: AppFeatureFlagOverrideSupport?
    
    init() { AppFeatureFlagOverrideSupport.shared = self }
    
    fileprivate let AppFeatureFlagUserDefaultsKey = "AppFeatureFlags"
    fileprivate var _AppFeatureFlagOverridesCache: [String:Bool]? = nil
    
    func invalidateCache() { _AppFeatureFlagOverridesCache = nil }
    
    var overrides: [String:Bool]? {
        get {
            if _AppFeatureFlagOverridesCache == nil {
                _AppFeatureFlagOverridesCache = UserDefaults.standard.dictionary(forKey: AppFeatureFlagUserDefaultsKey) as? [String: Bool] ?? nil
            }
            
            return _AppFeatureFlagOverridesCache
        }
        set(newValue) {
            _AppFeatureFlagOverridesCache = newValue
            
            UserDefaults.standard.setValue(newValue, forKey: AppFeatureFlagUserDefaultsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func clearFlag(flag: AppFeatureFlag) {
        guard var overrides = self.overrides else { print("no overrides!"); return }
        overrides.removeValue(forKey: flag.rawValue)
        self.overrides = overrides
    }
    
    func setFlag(flag: AppFeatureFlag, value: Bool) {
        var overrides = self.overrides ?? [:] // copy
        overrides[flag.rawValue] = value
        self.overrides = overrides // also sets it in UserDefaults
        
        print("set [\(flag.rawValue)] to \(value)")
    }
}

internal extension AppFeatureFlagProtocol {
    var id: Self { self }
    
    var symbol: String { "gear" }
    var description: String? { nil }
    
    var defaultValue: Bool { false }
    
    var value: Bool {
        guard let overrides = AppFeatureFlagOverrideSupport.shared?.overrides else { return defaultValue }
        let value = overrides[String(self.rawValue)]
        
        print("querying flag [\(self.rawValue)]: \(value ?? defaultValue)")
        
        return value ?? defaultValue
    }
}

internal enum AppFeatureFlag: String, AppFeatureFlagProtocol {
    case packets
    case enableGlobalSearch
    
    var symbol: String {
        switch self {
        case .enableGlobalSearch: "magnifyingglass.circle.fill"
        default: "gear"
        }
    }
    
    var defaultValue: Bool {
        switch self {
        case .enableGlobalSearch: true
        default: false
        }
    }
}

@MainActor internal func appFeatureFlagEnabled(_ flag: AppFeatureFlag) -> Bool {
    return flag.value
}
