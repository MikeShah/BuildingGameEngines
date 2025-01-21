// @file warmup.d
// dmd -g warmup.d -of=prog
import std.stdio;
import core.stdc.stdlib;

// What is the type of V?
// Where is it stored in memory?
const V = 42;
// Answer:
// Stored in global memory

extern(C) void main(){

	// What is the value of W?
	// Where is it stored in memory?
	int W;
	// Answer:
	// V holds int.init which is 0
	// Note: Floats initial value is 'NaN'

	// What is the value of X?
	// Where is it stored in memory?
	int* X = cast(int*)malloc(int.sizeof * 50);
	// Answer: 
	// Is stored on the stack
	// X holds pointer to memory in heap
	// Memory leak here if we do not 'free' X
	// Can use:
	// free(X); or
	// scope(exit) { free(X); } 

	// What is the value of Y?
	// Where is it stored in memory?
	int[] Y = new int[100];
	// Answer: 
	// Y stored on stack. Points to heap memory
	// that is managed by D's garbage collector.

	// What is the value of Z?
	// Where is it stored in memory?
	static Z = 7L;
	// Answer:
	// Global section of memory, scope is within main
}
