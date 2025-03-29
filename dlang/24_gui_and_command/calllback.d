// @file: callback.d
import std.stdio;

float addf(float a, float b){
	return a + b;
}

void main(){

		// Function pointer
		// This can be assigned at run-time to any function
		// that takes in two floats as arguments and returns a float.
		float function(float,float) callback_f_ff = &addf;

		auto result = callback_f_ff(2.2f,7.3f);

		writeln("result is ", result);
}
