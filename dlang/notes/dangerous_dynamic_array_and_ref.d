/// This is an example of something NOT to do.
/// 
/// The issue can arise when using 'ref' and dynamic arrays.
/// Do not assign a dynamic array to something of 'local scope',
/// whether directly, or a slice of a local array.
import std.stdio;

void foo(ref int[] dynamicArray){
	int[5] local = [1,2,3,4,5];				//

	dynamicArray = local[1..2];				// THIS IS BAD
//	dynamicArray = local[1..2].dup;	// This is a possible fix, .dup will
																		// allocate on the heap a copy, and be
																		// new memory.
	writeln("Inside local function: ",dynamicArray);
}

void main(){
	
	int[] dynamic = [1,2,3,4];
	foo(dynamic);

	writeln("outside of function  : ",dynamic);
}
