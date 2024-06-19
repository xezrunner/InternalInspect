import Foundation
import SwiftUI

struct PacketGroupSectionView: View {
    init(_ group: PacketGroup) {
        self.group = group
    }
    
    @Namespace var packetList
    var group: PacketGroup
    
    @EnvironmentObject var featureFlags: GlobalFeatureFlags
    
    var body: some View {
        Section(group.handlePath) {
            ForEach(group.packets) { packet in
                NavigationLink {
                    if (!featureFlags.getBool(name: "UseZoomTransitions")) {
                        PacketDetailView(packet: packet)
                    } else {
                        PacketDetailView(packet: packet)
                            .navigationTransition(.zoom(sourceID: packet.id, in: packetList))
                    }
                } label: {
                    VStack(alignment: .leading) {
                        if packet.packetType == .PACKET_ELIGIBILITY {
                            HStack {
                                Text("os_eligibility_get_domain_answer(\(packet.funcName))")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(packet.hasSymbol ? Color.accentColor : Color(UIColor.quaternaryLabel))
                                if packet.eligibilityLookupResult?.domainCode != -1 {
                                    Text("\(packet.eligibilityLookupResult!.domainCode)")
                                        .foregroundStyle(.gray).opacity(0.5)
                                }
                            }
                        } else {
                            let funcArgs = packet.funcArgs.isEmpty ? "" : packet.funcArgs.map { element in "\"\(element)\""}.joined(separator: ", ")
                            Text("\(packet.funcName)(\(funcArgs))")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(packet.hasSymbol ? Color.accentColor : Color(UIColor.quaternaryLabel))
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
                                        if packet.eligibilityLookupResult == nil {
                                            Text("Eligibility lookup failed.").padding([.leading], -10).font(.footnote.bold())
                                                .foregroundColor(.red)
                                        } else {
                                            Text("\(packet.eligibilityLookupResult!.answer.name())").padding([.leading], -10).font(.footnote.bold())
                                                .foregroundStyle(packet.eligibilityLookupResult!.answer == .EligibilityAnswerEligible ? .green : .gray)
                                        }
                                    }
                                    
                                }
                            }
                        }
                        .font(.footnote)
                        .foregroundStyle(.primary)
                    }
                }
                .matchedTransitionSource(id: packet.id, in: packetList)
            }
            .foregroundStyle((access(group.handlePath, F_OK) != 0) ? .secondary : .quaternary)
        }
        .monospaced()
        .font(.system(size: 12))
        .textCase(.none)
        .listSectionSpacing(0)
    }
}
