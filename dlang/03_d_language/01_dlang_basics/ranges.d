// @file: dlang_basics/ranges.d
import std.stdio;

void main(){

	int[] arr = [1,2,3,4,5];
	
	foreach( element; arr){
		write(element,",");
	}
	writeln();

	foreach_reverse(element; arr){
		write(element,",");
	}
	writeln();

	// Just look at a slice
	// $ - is a shortcut for the 'end' of an array
	foreach( element ; arr[ arr.length-2 .. $] ){
		write(element,",");
	}
	writeln();
}
