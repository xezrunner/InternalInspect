import SwiftUI

struct ConsoleLineInfo: Hashable {
    let fileName    : String
    let functionName: String
    let lineNumber  : Int
    
    // TODO: log category
    
    let text: String
}

struct ConsoleLineEntry: View {
    let lineInfo: ConsoleLineInfo
    let index: Int
    
    @Binding var selection: Int?
    
    var isSelected: Bool {
        get { return selection ?? -1 == index }
    }
    
    @State var lineLimit = 2
    @State var expanded = false
    
    var body: some View {
        Label(
            title: {
                VStack(alignment: .leading, spacing: 6) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(lineInfo.functionName).bold()
                        
                        HStack(spacing: 0) {
                            Text(lineInfo.fileName)
                            Text(": line \(lineInfo.lineNumber)").opacity(0.75)
                        }
                        .font(.footnote)
                        .dynamicTypeSize(.xSmall)
                        .foregroundStyle(.secondary)
                    }
                    
                    Text(lineInfo.text)
                        .lineLimit(!expanded ? lineLimit : .none)
                        .font(.system(size: !expanded ? 11 : 12))
                        //.fixedSize(horizontal: false, vertical: true)
                }
            },
            icon: {}
        )
        .labelStyle(.titleOnly)
        .font(.system(size: 13))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

struct ConsoleView: View {
    @State var selection: Int? = nil
    
    @State private var fullWidth: CGFloat = 0.0
    
    var body: some View {
        List(0..<globalState.consoleLines.count, id: \.self, selection: $selection) { index in
            let entry = globalState.consoleLines[index]
            ConsoleLineEntry(lineInfo: entry, index: index, selection: $selection)
                .contextMenu(
                    menuItems: {
                        Button("Copy", action: {}).disabled(true)
                    },
                    preview: {
                        ScrollView {
                            ConsoleLineEntry(lineInfo: entry, index: index, selection: $selection, expanded: true)
                                .frame(idealWidth: fullWidth, maxHeight: .infinity)
                                .padding()
                        }
                    })
        }
        .monospaced()
        .scrollContentBackground(.hidden)
        .overlay {
            // This is needed for .contextMenu to be full-width:
            GeometryReader { geo in
                Color.clear.onAppear { self.fullWidth = geo.frame(in: .local).size.width }
            }
        }
    }
}

#Preview {
    ConsoleView()
        .environmentObject(GlobalState())
}
