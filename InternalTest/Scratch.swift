//
//  Scratch.swift
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//

import SwiftUI

struct Scratch: View {
    var body: some View {
        List(0...3, id: \.self) { index in
            Text(index.description)
        }
    }
}

#Preview {
    Scratch()
}
