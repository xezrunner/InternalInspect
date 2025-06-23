// InternalTest::FeatureFlagDomainEntryView.swift - 24.06.2025
import SwiftUI

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
