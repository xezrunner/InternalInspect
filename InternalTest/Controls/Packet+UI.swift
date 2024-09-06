import SwiftUI

extension Packet {
    var resultColor: Color {
        get {
            switch self.packetType {
            case .PACKET_ELIGIBILITY:
                switch self.eligibilityLookupResult?.answer {
                case .EligibilityAnswerEligible:    return .green
                case .EligibilityAnswerNotEligible: return .red
                default:                            return .secondary // TODO: ?
                }
            case .PACKET_C: fallthrough
            case .PACKET_OBJC:
                return self.result ? .green : .red
            }
        }
    }
    
    // TODO: complex!
    func getPacketSymbol() -> String {
        switch self.packetType {
        case .PACKET_C:    fallthrough
        case .PACKET_OBJC:
            if self.result { return "gear.circle.fill" }
            else { return "nosign.app.fill" }
        case .PACKET_ELIGIBILITY:
            if self.eligibilityLookupResult == nil || self.eligibilityLookupResult!.error != 0 {
                return "exclamationmark.lock.fill"
            } else {
                if self.eligibilityLookupResult!.answer == .EligibilityAnswerEligible {
                    return "checkmark.shield.fill"
                } else {
                    return "lock.circle.dotted"
                }
            }
        }
    }
    
    func getPacketTitle() -> String {
        switch self.packetType {
        case .PACKET_C:           return "\(self.funcName)()"
        case .PACKET_OBJC:        fallthrough
        case .PACKET_ELIGIBILITY: return self.funcName
        }
    }
    
    func getPacketResultText() -> String {
        switch self.packetType {
        case .PACKET_ELIGIBILITY:
            if self.eligibilityLookupResult == nil || self.eligibilityLookupResult?.error != 0 {
                return "Eligibility lookup error"
            } else {
                return self.eligibilityLookupResult!.answer.name()
            }
        case .PACKET_C: fallthrough
        case .PACKET_OBJC:
            // TODO: this really shouldn't be string-specific..
            if self.isStringReturnType { return "\"\(self.stringResult)\"" }
            else                       { return String(self.result) }
        }
    }
}
