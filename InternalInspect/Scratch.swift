//
//  Scratch.swift
//  InternalInspect
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

struct Scratch: View {
    var body: some View {
        NavigationView {
            List(0...3, id: \.self) { index in
                Text(index.description)
            }
            .toolbar {
                ToolbarItem {
                    Button("Test", systemImage: "gear") { }
                }
            }
        }
#if !os(macOS)
        .navigationViewStyle(StackNavigationViewStyle())
#endif
    }
}

#Preview {
    Scratch()
}
