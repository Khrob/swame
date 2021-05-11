import Darwin

@_cdecl("external_func")
public func external_func (_ delta:Float)
{
	print ("How do you like my random timings? \(delta)")
	usleep(UInt32.random(in:1000...300000))
}
