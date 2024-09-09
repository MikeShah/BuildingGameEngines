// @file: function_stack.d
import std.stdio;

auto add(T)(T a, T b){
	return a+b;
}

void main(){
	int result = add(7,2);
	writeln("result:",result);
}
