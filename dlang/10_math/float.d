// @file: float.d
import std.stdio;
import std.math.operations;

void main(){

	// False, floating point is now quite precise enough

	float one_third = 1.0/3.0;
	writeln("one_third=",one_third);
	writeln;

	// Test for equivalence
	if(one_third == 0.333_333_333){
		writeln("1.0/3.0 == 0.333_333_333");
	}

	// True, these values are close
	if (isClose(one_third,0.333_333_333)){
		writeln("isClose(1.0/3.0,0.333_333_333)");
	}
}
