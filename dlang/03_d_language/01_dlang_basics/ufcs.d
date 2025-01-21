// @file dlang_basics/ufcs.d
import std.stdio;
import std.algorithm; // For map

void main(){

	// Traditional way of writing code
	auto functionCall = map!(a=> a*2)([1,2,3]);
	writeln(functionCall);

	// Use of ufcs
	// Observe how argument was moved
	//          .------------------- ([1,2,3])
	//          v
	auto ufcs = [1,2,3].map!(a=> a*2);
	writeln(ufcs);

}
