import Foundation

class PacketGroup: Identifiable {
    init(handlePath: String, _ packetDefinitions: [PacketDefinition]) {
        self.handlePath = handlePath
        self.packetDefinitions = packetDefinitions
        
        // Resolve handle:
        let _handle: UnsafeMutableRawPointer! = dlopen(handlePath, RTLD_NOW)
        print("handle: (\(handle.debugDescription))")
        if _handle != nil { handle = _handle }
        
        // Assign the group for each packet and resolve them:
        packetDefinitions.forEach { definition in
            let packet: Packet = .init(definition.funcName, definition.funcArgs, packetType: definition.packetType, isStringReturnType: definition.isStringReturnType)
            packet.packetGroup = self
            packet.selfResolve()
            packets.append(packet)
        }
    }
    
    let id = UUID()
    
    let handlePath: String
    var handle:     UnsafeMutableRawPointer!
    
    var packetDefinitions: [PacketDefinition] = []
    var packets: [Packet] = []
}

enum PacketType: Int, Codable {
    case PACKET_C = 0
    case PACKET_OBJC = 1
    case PACKET_ELIGIBILITY = 999
}

struct PacketDefinition: Codable {
    init(packetType: PacketType = .PACKET_C, _ funcName: String, _ funcArgs: String..., isStringReturnType: Bool = false) {
        self.packetType = packetType
        self.funcName = funcName
        self.funcArgs = funcArgs
        self.isStringReturnType = isStringReturnType
    }
    
    let packetType: PacketType
    
    let funcName: String
    let funcArgs: [String]
    
    let isStringReturnType: Bool
}

class Packet: Hashable, Identifiable {
    // TODO: TEMP:
    static func == (lhs: Packet, rhs: Packet) -> Bool {
        return lhs.id == rhs.id // TEMP
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(_ funcName: String, _ funcArgs: [String], packetType: PacketType = PacketType.PACKET_C, isStringReturnType: Bool = false) {
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
    
    var isResultSuccessful: Bool {
        get {
            switch self.packetType {
            case .PACKET_ELIGIBILITY:
                return self.eligibilityLookupResult?.answer == .EligibilityAnswerEligible
            case .PACKET_C:    fallthrough
            case .PACKET_OBJC: return self.result
            }
        }
    }
    
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
        
        let result: String?
        
        switch packetType {
        case .PACKET_C:
            result = RESOLVE_C_STRING()
        case .PACKET_OBJC:
            print("Objective-C string resolving not yet implemented!")
            return ""
        case .PACKET_ELIGIBILITY:
            print("Eligibility function not supported for RET:string functions!")
            return ""
        }
        
        self.result = result != nil
        return result ?? "<failed>"
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
    
    private func RESOLVE_C_STRING() -> String? {
        let symbol = RESOLVE_C()
        if symbol == nil || funcArgs.count == 0 { return nil }
        
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
        let result = ELIGIBLITY_RESOLVE(funcName)
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
        if (parts.count != 2) {
            print(print("Invalid Objective-C method format for \(funcName)"))
            return false
        }
        
        let isClassMethod = parts[0].hasPrefix("+[")
        
        let className  = String(parts[0].dropFirst(2))
        let methodName = String(parts[1].dropLast())
        
        let theClass: AnyClass? = objc_getClass(className) as? AnyClass
        if (theClass == nil) {
            print("failed to get base class for \(className): \(methodName)")
            return false
        }
        print("found class: \(className)")
        
        let result: CBool
        let method: Method?
        
        if isClassMethod {
            // +[Class methods]:
            let selector = sel_getUid(methodName)
            if !theClass!.responds(to: selector) {
                print("+[: class did not respond to selector \(selector) for \(className): \(methodName)")
                return false
            }
            hasSymbol = true
            method = theClass?.method(for: selector)
        } else {
            // -[Instance methods]:
            
            // Get the shared instance of the class:
            let sharedInstanceSelector: Selector = sel_getUid("sharedInstance") // TODO: could differ!
            let sharedInstanceTestResponse: Bool = theClass!.responds(to: sharedInstanceSelector)
            if (!sharedInstanceTestResponse) {
                print("-[: class did not respond to selector \(sharedInstanceSelector) for \(className): \(methodName)")
                return false
            }
            
            let sharedInstanceMethodImpl = theClass!.method(for: sharedInstanceSelector)
            let sharedInstanceMethod = unsafeBitCast(sharedInstanceMethodImpl, to: instancePrototype.self)
            let sharedInstanceResult : AnyClass? = sharedInstanceMethod() // TODO: test for fail!
            
            // Get the method:
            let targetSelector = sel_getUid(methodName)
            let targetTestResponse: Bool = sharedInstanceResult!.responds(to: targetSelector)
            self.hasSymbol = targetTestResponse
            if (!targetTestResponse) {
                print("-[: instance did not respond to selector \(targetSelector)")
                return false
            }
            
            method = sharedInstanceResult?.method(for: targetSelector)
        }
        
        if (method == nil) {
            print("failed to get method for \(funcName)")
            return false
        }
        print("got method: \(methodName) for \(funcName)")
        
        let callableMethod = unsafeBitCast(method, to: FunctionPrototypeBool.self)
        result = callableMethod()
        
        return result
    }
}
