import SwiftUI

struct PacketDetailView: View {
    func visualInfoForEligiblityAnswer(_ answer: EligiblityAnswer) -> (color: Color, systemImage: String) {
        switch answer {
        case .EligibilityAnswerEligible:        return (.green,   "checkmark.circle.fill")
        case .EligibilityAnswerMaybe:           return (.primary, "questionmark.circle.fill")
        case .EligibilityAnswerNotYetAvailable: fallthrough
        case .EligibilityAnswerNotEligible:     return (.red,     "x.circle.fill")
        default:                                return (.gray,    "questionmark.circle.fill")
        }
    }
    
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
                if packet.packetType != .PACKET_ELIGIBILITY {
                    Text("Function name")
                        .font(.footnote.bold())
                        .textCase(.uppercase)
                    
                    let funcArgs = packet.funcArgs.isEmpty ? "" : packet.funcArgs.map { element in "\"\(element)\""}.joined(separator: ", ")
                    Text("\(packet.funcName)(\(funcArgs))")
                        .bold()
                        .foregroundStyle(packet.hasSymbol ? Color.accentColor : Color(UIColor.tertiaryLabel))
                } else {
                    Text("DOMAIN")
                        .font(.footnote.bold())
                        .textCase(.uppercase)
                    
                    HStack {
                        Text("\(packet.funcArgs[0])")
                            .bold()
                            .foregroundStyle(packet.eligibilityLookupResult != nil ? Color.accentColor : Color(UIColor.tertiaryLabel))
                        
                        if packet.eligibilityLookupResult != nil {
                            Text("\(packet.eligibilityLookupResult!.domainCode)")
                                .foregroundStyle(.gray).opacity(0.5)
                        }
                    }
                }
                
                
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
                        if packet.packetType != .PACKET_ELIGIBILITY {
                            if !packet.isStringReturnType {
                                Label("\(packet.result)", systemImage: packet.result ? "checkmark.circle.fill" : "x.circle.fill")
                                    .foregroundStyle(packet.result ? Color.green : (packet.hasSymbol ? .red : .gray))
                                    .bold()
                            } else {
                                Label("\"\(packet.stringResult)\"", systemImage: "text.quote")
                                    .bold()
                            }
                        } else {
                            if packet.eligibilityLookupResult == nil {
                                Label("Eligibility lookup failed.", systemImage: "x.circle.fill")
                                    .bold()
                                    .foregroundStyle(.red)
                            } else {
                                let error = packet.eligibilityLookupResult!.error
                                if error == ELIGIBILITY_DOMAIN_NOT_FOUND_ERROR_CODE {
                                    Label("Domain not found (\(error))", systemImage: "questionmark.circle.fill")
                                        .bold()
                                        .foregroundStyle(.gray)
                                } else if error != 0 {
                                    Label("Error. Code: \(error)", systemImage: "x.circle.fill")
                                        .bold()
                                        .foregroundStyle(.red)
                                }
                                else {
                                    let answerVisualInfo = visualInfoForEligiblityAnswer(packet.eligibilityLookupResult!.answer)
                                    Label("\(packet.eligibilityLookupResult!.answer.name())", systemImage: answerVisualInfo.systemImage)
                                        .bold()
                                        .foregroundStyle(answerVisualInfo.color)
                                }
                            }
                        }
                    }.padding(.top, 1)
                }
            }
            .padding()
        }
        .font(.subheadline)
        .monospaced()
    }
}

#Preview {
    let exampleGroup = PacketGroup(handlePath: "/usr/lib/system/libsystem_darwin.dylib", [
            //Packet("os_variant_has_internal_diagnostics"),
            Packet("eligibility", "OS_ELIGIBILITY_DOMAIN_GREYMATTER", packetType: .PACKET_ELIGIBILITY),
        ])
    
    PacketDetailView(packet: exampleGroup.packets.first!)
}
