import SwiftUI

struct PacketListLabel: View {
    @State var packet: Packet
    
    let symbolSize: CGFloat = 22
    
    var body: some View {
        if !is_feature_flag_enabled("UseLegacyListItem") {
            Label(title: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(packet.getPacketTitle())
                        .foregroundStyle(packet.isResultSuccessful ? .primary : .secondary)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Result:").bold()
                        
                        Text(packet.getPacketResultText())
                            .foregroundStyle(packet.resultColor)
                            .bold(packet.isResultSuccessful)
                    }
                }
            }, icon: {
                Image(systemName: packet.getPacketSymbol())
                    .resizable().scaledToFit()
                    .frame(width: symbolSize, height: symbolSize)
                    .foregroundStyle(packet.isResultSuccessful ? .primary : .secondary)
            })
            .dynamicTypeSize(.xSmall)
        }
        else {
            VStack(alignment: .leading) {
                if packet.packetType == .PACKET_ELIGIBILITY {
                    HStack {
                        Text("os_eligibility_get_domain_answer()\n\(packet.funcName)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(packet.eligibilityLookupResult?.error == 0 ? (packet.eligibilityLookupResult?.answer == .EligibilityAnswerEligible ? Color.accentColor : Color.gray) : Color(Color.quaternaryLabel))
                        if packet.eligibilityLookupResult?.error == 0 {
                            Text("\(packet.eligibilityLookupResult!.domainCode)")
                                .foregroundStyle(.gray).opacity(0.5)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                        }
                    }
                } else {
                    let funcArgs = packet.funcArgs.isEmpty ? "" : packet.funcArgs.map { element in "\"\(element)\""}.joined(separator: ", ")
                    Text("\(packet.funcName)(\(funcArgs))")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(packet.hasSymbol ? Color.accentColor : Color(Color.quaternaryLabel))
                }
                
                VStack(alignment: .leading) {
                    VStack {
                        if packet.hasSymbol { /*{ Text("Symbol found.")    .foregroundStyle(.blue) }*/ }
                        else                    { Text("Symbol not found.").foregroundStyle(.gray) }
                    }.font(.footnote)
                    
                    if packet.hasSymbol {
                        HStack {
                            Text("Result: ")
                            
                            if packet.packetType != .PACKET_ELIGIBILITY {
                                if !packet.isStringReturnType {
                                    Text("\(packet.result)").foregroundStyle(packet.result ? Color.green : (packet.hasSymbol ? .red : .gray)).padding([.leading], -10)
                                        .font(.footnote.bold())
                                } else {
                                    Text("\"\(packet.stringResult)\"").padding([.leading], -10).font(.footnote.bold())
                                }
                            } else {
                                if packet.eligibilityLookupResult == nil || packet.eligibilityLookupResult!.error != 0 {
                                    Text("Eligibility lookup failed.").padding([.leading], -10).font(.footnote.bold())
                                        .foregroundColor(.gray)
                                } else {
                                    Text("\(packet.eligibilityLookupResult!.answer.name())").padding([.leading], -10).font(.footnote.bold())
                                        .foregroundStyle(packet.eligibilityLookupResult!.answer == .EligibilityAnswerEligible ? .green : .gray)
                                }
                            }
                            
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
        }
    }
}
