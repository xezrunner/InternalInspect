import SwiftUI
import SystemColors

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
    
    @EnvironmentObject var featureFlags: GlobalFeatureFlags
    
    @State var packet: Packet
    
    @State var heroAnimationTrigger = 0
    
    func getHeroMainIcon() -> String {
        switch packet.packetType {
        case .PACKET_C:    fallthrough
        case .PACKET_OBJC:
            if packet.result { return "gear.circle.fill" }
            else { return "nosign.app.fill" }
        case .PACKET_ELIGIBILITY:
            if packet.eligibilityLookupResult == nil || packet.eligibilityLookupResult!.error != 0 {
                return "exclamationmark.lock.fill"
            } else {
                if packet.eligibilityLookupResult!.answer == .EligibilityAnswerEligible {
                    return "checkmark.shield.fill"
                } else {
                    return "lock.circle.dotted"
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Image(systemName: getHeroMainIcon())
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 64, maxHeight: 64)
                    .padding()
                    .opacity(packet.hasSymbol ? 1 : 0.4)
                    .symbolEffect(.bounce.byLayer.down, value: heroAnimationTrigger)
                    .onTapGesture { heroAnimationTrigger += 1 }
                    .onAppear(perform: { heroAnimationTrigger += 1} )
                
                if packet.packetType != .PACKET_ELIGIBILITY && !packet.hasSymbol {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 30, maxHeight: 30)
                        .offset(x: 25, y: -25)
                        .symbolEffect(.bounce.byLayer.up, value: heroAnimationTrigger)
                }
            }
            .background(Color.gray.opacity(0.10).gradient)
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
                        .foregroundStyle(packet.hasSymbol ? Color.accentColor : Color(Color.tertiaryLabel))
                } else {
                    Text("DOMAIN")
                        .font(.footnote.bold())
                        .textCase(.uppercase)
                    
                    HStack {
                        Text("\(packet.funcName)")
                            .bold()
                            .foregroundStyle(packet.eligibilityLookupResult != nil ? Color.accentColor : Color(Color.tertiaryLabel))
                        
                        if packet.eligibilityLookupResult?.domainCode != -1 {
                            Text("\(packet.eligibilityLookupResult!.domainCode)")
                                .foregroundStyle(.gray).opacity(0.5)
                        }
                    }
                    
                    if (packet.packetType == .PACKET_ELIGIBILITY && featureFlags.getBool(name: "ShowDebugInformation")) {
                        if (packet.eligibilityLookupResult?.error != 0){
                            Text("ERROR")
                                .font(.footnote.bold())
                                .textCase(.uppercase)
                            
                            Text("\(packet.eligibilityLookupResult!.error)")
                                .bold()
                        }
                    }
                }
                
                
                Text("LIBRARY")
                    .font(.footnote.bold())
                    .textCase(.uppercase)
                    .padding(.top, 8)
                
                Text("\(packet.packetGroup?.handlePath ?? "nil")")
                    .foregroundStyle(packet.hasSymbol ? Color.primary : Color(Color.tertiaryLabel))
                
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
        PacketDefinition(packetType: .PACKET_ELIGIBILITY, "OS_ELIGIBILITY_DOMAIN_GREYMATTER")
        ])
    
    PacketDetailView(packet: exampleGroup.packets.first!)
        .environmentObject(GlobalFeatureFlags())
}
