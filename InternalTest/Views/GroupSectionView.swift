import Foundation
import SwiftUI

struct PacketGroupSectionView: View {
    init(_ group: PacketGroup) {
        self.group = group
    }
    
    var group: PacketGroup
    
    var body: some View {
        Section(group.handlePath) {
            
            ForEach (group.packets) { packet in
                Button(action: {}, label: {
                    VStack(alignment: .leading) {
                        
                        Text("\(packet.funcName)\(packet.funcArg != nil ? "(\"\(packet.funcArg!)\")" : "")")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(packet.hasSymbol ? Color.accentColor : Color(UIColor.quaternaryLabel))
                        
                        VStack(alignment: .leading) {
                            VStack {
                                if packet.hasSymbol { /*{ Text("Symbol found.")    .foregroundStyle(.blue) }*/ }
                                else                    { Text("Symbol not found.").foregroundStyle(.gray) }
                            }.font(.footnote)
                            
                            if packet.hasSymbol {
                                HStack {
                                    Text("Result: ")
                                    if !packet.isStringArg {
                                        Text("\(packet.result)").foregroundStyle(packet.result ? Color.green : (packet.hasSymbol ? .red : .gray)).padding([.leading], -10)
                                            .font(.footnote.bold())
                                    } else {
                                        Text("\"\(packet.stringResult)\"").padding([.leading], -10).font(.footnote.bold())
                                    }
                                    
                                }
                            }
                        }
                        .font(.footnote)
                        .foregroundStyle(.primary)
                    }
                    .monospaced()
                })
            }
        }
        .foregroundStyle((access(group.handlePath, F_OK) != 0) ? .secondary : .quaternary)
        .textCase(.none)
    }
}
