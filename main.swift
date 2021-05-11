import Foundation

struct Engine
{
	var tick : ((Float)->())!
	var last_tick_start : Date = Date()
	var should_exit = false
}

struct Library
{
	let path      : String
	var last_seen : Date!
	var handle	  : UnsafeMutableRawPointer!
	var symbol	  : UnsafeMutableRawPointer!
}

var engine = Engine()
var lib = Library(path:"./game.dylib")
load_library(&lib, &engine)

repeat {

	// Check if we need to load the new dylib
	if file_updated (lib.path, lib.last_seen).0 { load_library(&lib, &engine) }

	// call the tick

	let delta = Float(-engine.last_tick_start.timeIntervalSinceNow)
	engine.last_tick_start = Date()
	engine.tick(delta)

} while engine.should_exit == false




func load_library (_ library:inout Library, _ engine:inout Engine)
{
	dlclose(library.handle)

	library.handle = dlopen(library.path, RTLD_NOW)
	if let s = dlerror() { print(String(cString: s)) } 
	if library.handle == nil { print("Couldn't load the libary"); exit(0) }

	// Get the function's symbol
	library.symbol = dlsym(library.handle, "external_func")
	if let t = dlerror() { print(String(cString: t)); exit(0) } 
	if library.symbol == nil { print("Couldn't find the external function"); exit(0) }

	// Cast the unsafe pointer symbol to a swift callable func
	typealias func_alias = @convention(c) (Float)->()
	engine.tick = unsafeBitCast(library.symbol, to:func_alias.self)

	print("Updated the dylib")
	print(library.handle as Any)
	print(library.symbol as Any)

	library.last_seen = file_modified(library.path)
}

func file_updated (_ path:String, _ date:Date) -> (Bool, Date)
{
	if let d = file_modified(path) {  
		let newer = d > date
		return (newer, newer ? d : date)  
	}
	return (false, date)
}

func file_modified (_ path:String) -> Date?
{
	return (try? FileManager.default.attributesOfItem(atPath: path))?[.modificationDate] as? Date
}
