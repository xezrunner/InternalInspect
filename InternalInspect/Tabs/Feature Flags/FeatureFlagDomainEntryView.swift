// InternalInspect::FeatureFlagDomainEntryView.swift - 24.06.2025
import SwiftUI

struct FeatureFlagDomainEntryView: View {
    @Environment(FeatureFlagsTabState.self) var state
    
    @State var domain: String
    @State var features: FeatureFlags_FeaturesDictionary
    @State var isProgress = false
    
    var body: some View {
        Group {
            NavigationLink(value: domain) {
                HStack {
                    Text(domain)
                    Spacer()
                    Text("\(features.count)").font(.footnote)
                }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                if canDeleteDomain {
                    deleteButton
                }
            }
            .contextMenu {
                deleteButton
                .disabled(!canDeleteDomain)
            }
        }
    }
    
    // Deleting a domain will delete all custom tracked features that were added by the user.
    // It does not delete it from the system.
    
    var deleteButton: some View {
        Button(role: .destructive, action: deleteDomain) {
            Label("Delete manually added features or domains", systemImage: "trash")
        }
    }
    
    var canDeleteDomain: Bool {
        return features.values.contains { $0.isAddedByUser }
    }
    
    func deleteDomain() {
        FeatureFlagsSupport.deleteUserAdded(domain: domain)
        state.reloadDictionary()
    }
}
