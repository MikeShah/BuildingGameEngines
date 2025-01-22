/// @file dlang_basics/unittest.d
/// Run with either: rdmd -unittest unittest.d
/// Or if no main() functin provided
/// Run with: rdmd -main -unitteset d_file_here.d

import std.stdio;

// Generic 'sum' function
auto sum(T)(T a, T b){
	return a + b;
}

void main(){
	writeln("This will not run with -unittest flag");
}

unittest{
	assert(sum(1,2) == 3, "1+2==3 did not pass");
}

unittest{
	assert(sum((1.0f/3.0f),(2.0f/3.0f)) == 1.0f, "(1/3)+(2/3)==3.0f did not pass");
}

unittest{
	import std.math;
	// A better way to compare 'floating point' data.
	assert(isClose(sum(1.0f/3.0f,2.0f/3.0f), 1.0f), "1/3 + 2/3 isClose to 1.0f ");
}

