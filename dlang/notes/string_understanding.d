// Understanding how to work with strings and that they are an 'immutable' data type is one thing that 
// I often see folks struggle with.
//
// Below are some examples to otherwise help try to see where you can use strings.
// Otherwise, understand that 'cast' can be a dangerous thing, if you try to write into an immutable
// type, as this program will 'segfault'. 
//
// For more see: https://dlang.org/spec/arrays.html#strings

import std.stdio;
import std.string;

void main(){
	// c-style, this works, pointer to a string literal
	const char* works = "this works";

	// D style string
	string d_style = "this works";
	writeln("d_style type: ",typeid(d_style), " value=",d_style);

	// This works
	immutable(char)[] s1 = "long version of string declaration"; // This works
	writeln("s1 type     : ",typeid(s1), " value=",s1);

	// char[] s1 = "does not work"; // Does not compile 
	// cannot convert 'string' to 'char[]' implicitly.

	// This works, fixerd size string
	char[4] string_as_expected = "mike";
	assert(string_as_expected[2] == 'k');

	// This works, raw string
	char[] raw_string = new char[4];
	raw_string = cast(char[])"mike";
	assert(raw_string[2] == 'k');

	// These are the short ways to make a 'mutable' and 'immutable' strings
	// that you probably may want to do if you want to 'initialize' the 
	// char[] or immutable(char)[] otherwise;
	char[] mike = "mike".dup;
	auto 	 immutable_mike = "mike".idup; // Same as: string immutable_mike = "mike";
	writeln(typeid(immutable_mike));

	// Dangerous, "mike" is of type string, so we shouldn't be changing.
	// read-only data.
	// Explicit cast, that says 'trust me'
	char[] s2 = cast(char[])"mike1234";
	writeln("s2.ptr    :",s2.ptr);
	writeln("s2.length :",s2.length);
	writeln("s2[0] read:",s2[0]);
	s2[0] = 'M'; // this will cause 'segfault'
							 // Probably accessing 'read-only' memory here illegally.
	writeln("s2 type: ",typeid(s2));

}
