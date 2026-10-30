// @file compare2.d
import std.stdio;
import std.checkedint;

void main(){
	int value1 = -37;
	uint value2 = 57;

	if(checked(value1) > value2){
		writeln("MATH IS BROKEN?????????");
	}	

}
