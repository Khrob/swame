import Darwin

@_cdecl("external_func")
public func external_func (_ delta:Float)
{
	print ("How do you like my random timings? \(delta)")
	usleep(UInt32.random(in:1000...300000))
}

struct Data
{
	var one:Float
	var two:Int
}

@_cdecl("external_struct")
public func external_func (_ s:UnsafeMutableRawPointer)
{
	print("Being called")

	// var data_struct = s.load(as:Data.self)
	var data_struct = s.bindMemory(to:Data.self, capacity:MemoryLayout<Data>.size)
	print ("The struct contains: \(data_struct.one) \(data_struct.two)")

	let rf = Float.random(in:10.0...20.0)
	let ri = Int.random(in:0...50)

	data_struct.one = rf
	data_struct.two = ri
	usleep(UInt32.random(in:1000...300000))
}
