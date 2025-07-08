/// @file dlang_basics/associative_array2.d
import std.stdio;
import core.exception;

/// Example showing how to use an associtaive array
void main(){
	/// Associative array
	/// key = string
	/// value = int
	int[string] students = ["mike":123, "bob":456];

//  writeln(students["joe"]); // 'joe' is not in Associative array.
                              // This will give a 'Range violation which you
                              // can handle below.
  try{
    writeln(students["joe"]);
  }catch(RangeError e){
  }finally{
    writeln("Not here");
  }

  // You can also use 'get' which is a gentler way to handle 
  // keys that are not found by returning a value.
  // See more properties here: https://dlang.org/spec/hash-map.html#properties
  writeln(students.get("joe",-1));
  // Require will return a key if it exists, otherwise it will 'add' a key/value pair if it does not exist
  writeln(students.require("buddy",500));

  // The 'in' keyword can test if a key is 'in' (or '!in') the associative array
  // I'm also demonstrating the 'ternary' operator ? that evaluates the result to true/false
  bool buddyResult = "buddy" in students ? true : false;
  writeln("Is buddy in? ",buddyResult);

  writeln(students);
	writeln(students.length);	

}
