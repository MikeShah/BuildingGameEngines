// @file dlang_basics/struct.d
import std.stdio;

struct student{
	string name;
	int id;
}

void main(){
	
	// Create a struct on the stack
	student mike = student("mike",123);

	// Can also be heap allocated
	auto michael = new student("michael",456);
	//  The above line is equivalent to the below
	//  'auto' deduces the type as a pointer
    //	student* michael = new student("michael",456);

	// Note that 'mike' is a known struct
	// 'michael' is heap allocated, and represents an address
	writeln(mike);
	writeln(michael);
	writeln(*michael); // dereference 'michael' to get the value
}
