/// @file associative_array.d
import std.stdio;

/// Example showing how to use an associtaive array
void main(){
	/// Associative array
	/// key = int
	/// value = string
	string[int] students;

	students[12345] = "mike";
	writeln(students);	
	/// The order can be confusing sometimes
	/// here's an example for clarity where
	/// I use 'alias' as another name for
	/// 'string' for the purpose of showing you
	/// what the key is (between the []'s) and the
	/// value
	alias key 	= string;
	alias value = string;
	value[key] animals;

	/// Insert a new key or update key if it exists
	animals["dog"] = "an animal that barks";
	animals["cat"] = "an animal that meows";

	/// Check if dog exists
	if("dog" in animals){
		writeln("dog is here");
	}
	writeln(animals);
}
