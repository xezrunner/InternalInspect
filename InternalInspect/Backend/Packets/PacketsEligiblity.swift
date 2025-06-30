import Foundation

// os_eligibility_get_domain_answer(int, int*, ? ? ?)
typealias FunctionPrototypeEligibilityDomainAnswer = @convention(c) (_ arg0: Int, _ arg1: UnsafePointer<CInt>, _ arg2: UnsafePointer<CInt>?,_ arg3: UnsafePointer<CInt>?, _ arg4: UnsafePointer<CInt>?) -> CInt

// os_eligibility_domain_for_name(char*)
typealias FunctionPrototypeEligibilityDomainCodeForName = @convention(c) (_ arg0: UnsafePointer<CChar>) -> CInt

enum EligiblityAnswer: Int {
    case UNASSIGNED = -1
    case EligibilityAnswerInvalid = 0
    case EligibilityAnswerNotYetAvailable = 1
    case EligibilityAnswerNotEligible = 2
    case EligibilityAnswerMaybe = 3
    case EligibilityAnswerEligible = 4
    
    func name() -> String { return "\(self)" }
}

let ELIGIBILITY_DOMAIN_NOT_FOUND_ERROR_CODE = 22

public struct EligiblityLookupResult {
    init(_ domainCode: Int, _ answerResult: (error: Int, answer: Int)) {
        self.domainCode = domainCode
        self.answer = EligiblityAnswer(rawValue: answerResult.answer) ?? .UNASSIGNED
        self.error = answerResult.error
    }
    
    var domainCode: Int = -1
    var answer: EligiblityAnswer = .UNASSIGNED
    var error: Int = 0
}

public func ELIGIBLITY_RESOLVE(_ domain: String) -> EligiblityLookupResult? {
    let domainCode = C_CALL_SYMBOL_ELIGIBILITY_DOMAIN_CODE_FOR_NAME(domain)
    if domainCode == nil { return nil }

    let result = C_CALL_SYMBOL_ELIGIBILITY_DOMAIN_ANSWER(domainCode!)
    if result == nil { return nil }
    
    return EligiblityLookupResult(domainCode!, result!)
}

private func C_CALL_SYMBOL_ELIGIBILITY_DOMAIN_ANSWER(_ arg0: Int) -> (error: Int, answer: Int)? {
    let arg1Pointer = UnsafeMutablePointer<CInt>.allocate(capacity: 1)
    
    let symbol = RESOLVE_C_SYMBOL(handlePath: "/usr/lib/system/libsystem_eligibility.dylib", symbolName: "os_eligibility_get_domain_answer")
    if symbol == nil { return nil }
    
    let callable = unsafeBitCast(symbol, to: FunctionPrototypeEligibilityDomainAnswer.self)
    
    let result = Int(callable(arg0, arg1Pointer, nil, nil, nil))
    let answer = Int(arg1Pointer.pointee)
    
    if result != 0 { print("C_CALL_SYMBOL_ELIGIBILITY_DOMAIN_ANSWER: error \(result)") }
    
    free(arg1Pointer)
    return (result, answer)
}

private func C_CALL_SYMBOL_ELIGIBILITY_DOMAIN_CODE_FOR_NAME(_ arg0: String) -> Int? {
    let arg0AsCString = UnsafeMutablePointer<CChar>(mutating: (arg0 as NSString).utf8String)!
    
    let symbol = RESOLVE_C_SYMBOL(handlePath: "/usr/lib/system/libsystem_eligibility.dylib", symbolName: "os_eligibility_domain_for_name")
    if symbol == nil { return nil }
    
    let callable = unsafeBitCast(symbol, to: FunctionPrototypeEligibilityDomainCodeForName.self)
    
    let result = Int(callable(arg0AsCString))
    return result
}
