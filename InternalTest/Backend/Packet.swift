import Foundation

class PacketGroup: Identifiable {
    init(handlePath: String, _ packets: [Packet]) {
        self.handlePath = handlePath
        self.packets    = packets
        
        // Resolve handle:
        let _handle: UnsafeMutableRawPointer! = dlopen(handlePath, RTLD_NOW)
        print("handle: (\(handle.debugDescription))")
        if _handle != nil { handle = _handle }
        
        // Assign the group for each packet and resolve them:
        self.packets.forEach { packet in
            packet.packetGroup = self
            packet.selfResolve()
        }
    }
    
    let id = UUID()
    
    let handlePath: String
    var handle:     UnsafeMutableRawPointer!
    
    var packets: [Packet]
}

enum PacketType: Int, Codable {
    case PACKET_C = 0
    case PACKET_OBJC = 1
    case PACKET_ELIGIBILITY = 999
}

class Packet: Hashable, Identifiable {
    // TODO: TEMP:
    static func == (lhs: Packet, rhs: Packet) -> Bool {
        return lhs.id == rhs.id // TEMP
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(_ funcName: String, _ funcArgs: String..., packetType: PacketType = PacketType.PACKET_C, isStringReturnType: Bool = false) {
        self.funcName = funcName
        self.packetType = packetType
        self.funcArgs = funcArgs
        
        self.isStringReturnType = isStringReturnType
    }
    
    let id = UUID()
    
    var packetGroup: PacketGroup?
    
    let funcName:   String
    let packetType: PacketType
    let funcArgs:    [String]
    
    var hasSymbol: Bool = false
    
    var result:    Bool = false
    
    var isStringReturnType: Bool
    var stringResult: String = ""
    
    var eligibilityLookupResult: EligiblityLookupResult?
    
    public func selfResolve() {
        if packetType == .PACKET_ELIGIBILITY {
            self.eligibilityLookupResult = resolveEligibility()
        } else if isStringReturnType {
            self.stringResult = resolveString()
        } else {
            self.result = resolveBool()
        }
    }
    
    public func resolveString() -> String {
        if !isStringReturnType {
            print("Attempted to resolve as string when in fact a bool!")
            return ""
        }
        
        switch packetType {
        case .PACKET_C:
            return RESOLVE_C_STRING()
        case .PACKET_OBJC:
            print("Objective-C string resolving not yet implemented!")
            return ""
        case .PACKET_ELIGIBILITY:
            print("Eligibility function not supported for RET:string functions!")
            return ""
        }
    }
    
    public func resolveBool() -> Bool {
        if isStringReturnType {
            print("Attempted to resolve as bool when in fact a string!")
            return false
        }
        
        switch packetType {
        case .PACKET_C:
            return RESOLVE_C_BOOL()
        case .PACKET_OBJC:
            return RESOLVE_OBJC()
        case .PACKET_ELIGIBILITY:
            print("Eligiblity function not supported for RET:bool functions!")
            return false
        }
    }
    
    public func resolveEligibility() -> EligiblityLookupResult? {
        if packetType != .PACKET_ELIGIBILITY {
            print("This is not an eligiblity packet!")
            return nil
        }
        
        self.hasSymbol = true
        return RESOLVE_ELIGIBILITY()
    }
    
    private func RESOLVE_C_STRING() -> String {
        let symbol = RESOLVE_C()
        if symbol == nil || funcArgs.count == 0 { return "" }
        
        let result = C_CALL_SYMBOL_STRING_STRING_ARG(symbol, funcArgs[0]) as String
        return result
    }
    
    private func RESOLVE_C_BOOL() -> CBool {
        let symbol = RESOLVE_C()
        if symbol == nil { return false }
        
        let result = C_CALL_SYMBOL_BOOL(symbol, funcArgs)
        return result
    }
    
    private func RESOLVE_ELIGIBILITY() -> EligiblityLookupResult? {
        let result = ELIGIBLITY_RESOLVE(funcArgs[0])
        return result
    }
    
    private func RESOLVE_C() -> UnsafeMutableRawPointer! {
        if (packetGroup == nil) {
            print("packetGroup was null for packet \(funcName)!")
            return nil
        }
        
        let packetGroup = packetGroup!
        
        if packetGroup.handle == nil {
            print("Packet group for funcName \(funcName) has no handle pointer! It's supposed to be for handle \(packetGroup.handlePath).")
            return nil
        }
        
        let symbol: UnsafeMutableRawPointer! = dlsym(packetGroup.handle, funcName)
        print("symbol: \(funcName) [\(symbol.debugDescription)] (== nil: \(symbol == nil))")
        
        hasSymbol = symbol != nil
        if !hasSymbol { return nil }

        return symbol
    }
    
    private func RESOLVE_OBJC() -> Bool {
        if (packetGroup == nil) {
            print("packetGroup was null for packet \(funcName)!")
            return false
        }
        
        let packetGroup = packetGroup!
        
        if packetGroup.handle == nil {
            print("Packet group for funcName \(funcName) has no handle pointer! It's supposed to be for handle \(packetGroup.handlePath).")
            return false
        }
        
        let parts = funcName.components(separatedBy: " ")
            guard parts.count == 2, parts[0].hasPrefix("-[") else {
                print("Invalid Objective-C method format for \(funcName)")
                return false
            }
        
        let className  = String(parts[0].dropFirst(2))
        let methodName = String(parts[1].dropLast())
        
        let baseClass: AnyClass? = objc_getClass(className) as? AnyClass
        if (baseClass == nil) {
            print("failed to get base class for \(funcName)")
            return false
        }
        
        let sharedInstanceSelector: Selector = sel_getUid("sharedInstance") // TODO: could differ!
        let sharedInstanceTestResponse: Bool = baseClass!.responds(to: sharedInstanceSelector)
        if (!sharedInstanceTestResponse) {
            print("did not respond to selector \(sharedInstanceSelector)")
            return false
        }
        
        let sharedInstanceMethodImpl = baseClass!.method(for: sharedInstanceSelector)
        let sharedInstanceMethod = unsafeBitCast(sharedInstanceMethodImpl, to: instancePrototype.self)
        let sharedInstanceResult : AnyClass? = sharedInstanceMethod() // TODO: test for fail!
        
        let targetSelector = sel_getUid(methodName)
        let targetTestResponse: Bool = sharedInstanceResult!.responds(to: targetSelector)
        if (!targetTestResponse) {
            print("did not respond to selector \(targetSelector)")
            return false
        }
        
        hasSymbol = targetTestResponse
        
        let targetMethodImpl = sharedInstanceResult?.method(for: targetSelector)
        let targetMethod = unsafeBitCast(targetMethodImpl, to: FunctionPrototypeBool.self)
        
        let result = targetMethod()
        return result
    }
}
