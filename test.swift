import Darwin

// Open the dynamic library
let handle = dlopen("./game.dylib", RTLD_NOW)
if let s = dlerror() { print(String(cString: s)) } 
if handle == nil {  exit(0) }

// Get the function's symbol
let symbol = dlsym(handle, "external_func")
if let t = dlerror() { print(String(cString: t)); exit(0) } 
if symbol == nil {  exit(0) }

// Cast the unsafe pointer symbol to a swift callable func
typealias func_alias = @convention(c) ()->()
let function = unsafeBitCast(symbol, to:func_alias.self)

// Call it!
function()

// Clean up
dlclose(handle)