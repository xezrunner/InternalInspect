import SwiftUI

struct PacketDetailView: View {
    @State var packet: Packet
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Image(systemName: "gear.circle.fill")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 64, maxHeight: 64)
                    .padding()
                    .opacity(packet.hasSymbol ? 1 : 0.4)
                
                if !packet.hasSymbol {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 30, maxHeight: 30)
                        .offset(x: 25, y: -25)
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 18, style: .continuous))
            .padding(.vertical, 20)
            
            VStack(alignment: .leading) {
                Text("Function name")
                    .font(.footnote.bold())
                    .textCase(.uppercase)
                
                Text("\(packet.funcName)\(packet.funcArg != nil ? "(\"\(packet.funcArg!)\")" : "")")
                    .bold()
                    .foregroundStyle(packet.hasSymbol ? Color.accentColor : Color(UIColor.tertiaryLabel))
                
                Text("LIBRARY")
                    .font(.footnote.bold())
                    .textCase(.uppercase)
                    .padding(.top, 8)
                
                Text("\(packet.packetGroup?.handlePath ?? "nil")")
                    .foregroundStyle(packet.hasSymbol ? Color.primary : Color(UIColor.tertiaryLabel))
                
                Text("RESULT")
                    .font(.footnote.bold())
                    .textCase(.uppercase)
                    .padding(.top, 8)
                    
                if !packet.hasSymbol {
                    Text("Symbol not found.").foregroundStyle(.gray)
                } else {
                    HStack(spacing: 20) {
                        if !packet.isStringArg {
                            Label("\(packet.result)", systemImage: packet.result ? "checkmark.circle.fill" : "x.circle.fill")
                                .foregroundStyle(packet.result ? Color.green : (packet.hasSymbol ? .red : .gray))
                                .bold()
                        } else {
                            Label("\"\(packet.stringResult)\"", systemImage: "text.quote")
                                .bold()
                        }
                    }.padding(.top, 1)
                }
            }
        }
        .font(.subheadline)
        .monospaced()
    }
}

#Preview {
    let exampleGroup = PacketGroup(handlePath: "/usr/lib/system/libsystem_darwin.dylib", [
            Packet("os_variant_has_internal_diagnostics"),
        ])
    
    PacketDetailView(packet: exampleGroup.packets.first!)
}
