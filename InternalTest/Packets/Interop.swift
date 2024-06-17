import Foundation

typealias FunctionPrototypeBool      = @convention(c) ()               -> CBool
// TODO: TODO: TODO: Some functions want Swift 'String's (NSString?), others want raw C pointers.
// How should we determine what a function wants? Should we try, crash and try again? Seems hacky.
typealias FunctionPrototypeBoolArg   = @convention(c) (_ arg: String)  -> CBool
typealias FunctionPrototypeBoolArg2  = @convention(c) (_ arg0: UnsafePointer<CChar>, _ arg1: UnsafePointer<CChar>) -> CBool

typealias FunctionPrototypeStringArg = @convention(c) (_ arg: String) -> NSString

typealias instancePrototype = @convention(c) () -> AnyClass?

func C_CALL_SYMBOL_BOOL(_ symbol: UnsafeMutableRawPointer!, _ args: [String]) -> CBool {
    var result: CBool = false
    
    let argsAsCStrings = args.map { UnsafeMutablePointer<CChar>(mutating: ($0 as NSString).utf8String)! }
    
    switch args.count {
    case 0:  result = unsafeBitCast(symbol, to: FunctionPrototypeBool.self)()
    case 1:  result = unsafeBitCast(symbol, to: FunctionPrototypeBoolArg.self)(args[0])
    // TODO: is there seriously no better dynamic way to do this?
    case 2:  result = unsafeBitCast(symbol, to: FunctionPrototypeBoolArg2.self)(argsAsCStrings[0], argsAsCStrings[1])
    default: print("Only 0, 1 or 2 arguments are supported for functions that return a CBool.")
    }
    
    return result
}

func C_CALL_SYMBOL_STRING_STRING_ARG(_ symbol: UnsafeMutableRawPointer!, _ arg: String) -> NSString {
    let callable = unsafeBitCast(symbol, to: FunctionPrototypeStringArg.self)
    return callable(arg)
}
