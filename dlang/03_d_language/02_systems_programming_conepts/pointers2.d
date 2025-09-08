// @file pointers2.d

import std.stdio;

void main(){

	int[] arr = [1,2,3];
	arr ~= 5;
	writeln("&arr      : ",&arr);
	writeln("arr.ptr   : ",arr.ptr);
	writeln("arr.length: ",arr.length);

	writeln();

	// Expanding this example a bit more, 
	// observe what happens to an array's .ptr
	// address for a 'stack-allocated' pointer.
	int[3] arr2 = [1,2,3];
	arr2 ~= 4;
	writeln("&arr      : ",&arr2);
	writeln("arr.ptr   : ",arr2.ptr);
	writeln("arr.length: ",arr2.length);

}
