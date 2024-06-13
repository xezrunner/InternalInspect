import Foundation

typealias FunctionPrototypeBool    = @convention(c) ()              -> CBool
typealias FunctionPrototypeBoolArg = @convention(c) (_ arg: String) -> CBool
typealias FunctionPrototypeStringArg = @convention(c) (_ arg: String) -> NSString

typealias instancePrototype = @convention(c) () -> AnyClass?

func C_CALL_SYMBOL_BOOL(_ symbol: UnsafeMutableRawPointer!) -> CBool {
    let callable = unsafeBitCast(symbol, to: FunctionPrototypeBool.self)
    return callable()
}

func C_CALL_SYMBOL_BOOL_STRING_ARG(_ symbol: UnsafeMutableRawPointer!, _ arg: String) -> CBool {
    let callable = unsafeBitCast(symbol, to: FunctionPrototypeBoolArg.self)
    return callable(arg)
}

func C_CALL_SYMBOL_STRING_STRING_ARG(_ symbol: UnsafeMutableRawPointer!, _ arg: String) -> NSString {
    let callable = unsafeBitCast(symbol, to: FunctionPrototypeStringArg.self)
    return callable(arg)
}
