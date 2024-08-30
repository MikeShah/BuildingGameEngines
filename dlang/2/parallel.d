// @file: parallel.d
import std.parallelism;
import std.stdio;
import std.range; // For 'iota'
import std.array;

void main(){

	// Why the '.array' after 'iota'?
	// iota generates a 'range type' that fills our data from
	// 50 to 1000, and steps by 1.
	// The '.array' converts this range into an 'array' type so that we
	// can then modify the elements.
	auto data = iota(50,1000,1).array;
	// auto data = array(iota(50,1000,1)); // NOTE: This is equivalent
																				 // to the above line.

	foreach(ref elem ; data.parallel){
		elem += 1;
	}

	foreach(result ; data){
		writeln(result);
	}
}
