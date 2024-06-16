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

enum PacketType {
    case PACKET_C
    case PACKET_OBJC
}

class Packet: Hashable, Identifiable {
    // TODO: TEMP:
    static func == (lhs: Packet, rhs: Packet) -> Bool {
        return lhs.id == rhs.id // TEMP
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(_ funcName: String, _ funcArg: String? = nil, packetType: PacketType = PacketType.PACKET_C, isStringArg: Bool = false) {
        self.funcName = funcName
        self.packetType = packetType
        self.funcArg = funcArg
        
        self.isStringArg = isStringArg
    }
    
    let id = UUID()
    
    var packetGroup: PacketGroup?
    
    let funcName:   String
    let packetType: PacketType
    let funcArg:    String?
    
    var hasSymbol: Bool = false
    var result: Bool = false
    
    let isStringArg: Bool
    var stringResult: String = ""
    
    public func selfResolve() {
        if isStringArg {
            self.stringResult = resolveString()
            
        } else {
            self.result = resolveBool()
        }
    }
    
    public func resolveString() -> String {
        if !isStringArg {
            print("Attempted to resolve as string when in fact a bool!")
            return ""
        }
        
        switch packetType {
        case .PACKET_C:
            return RESOLVE_C_STRING()
        case .PACKET_OBJC:
            print("Objective-C string resolving not yet implemented!")
            return ""
        }
    }
    
    public func resolveBool() -> Bool {
        if isStringArg {
            print("Attempted to resolve as bool when in fact a string!")
            return false
        }
        
        switch packetType {
        case .PACKET_C:
            return RESOLVE_C_BOOL()
        case .PACKET_OBJC:
            return RESOLVE_OBJC()
        }
    }
    
    private func RESOLVE_C_STRING() -> String {
        let symbol = RESOLVE_C()
        if symbol == nil {
            return ""
        }
        
        let result = C_CALL_SYMBOL_STRING_STRING_ARG(symbol, funcArg!) as String
        return result
    }
    
    private func RESOLVE_C_BOOL() -> CBool {
        let symbol = RESOLVE_C()
        if symbol == nil {
            return false
        }
        
        let result = funcArg == nil ? C_CALL_SYMBOL_BOOL(symbol) : C_CALL_SYMBOL_BOOL_STRING_ARG(symbol, funcArg!)
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
