// @file mixin.d
// See results of mixin with:
// rdmd -mixin=mixin_output.txt mixin.d
import std.stdio;

// Combination of 'mixin' and 'template' can be very
// powerful even in simple examples.
auto BinaryOperation(string Op,T)(T a, T b){
	mixin("return a "~Op~" b;");
}

void main(){
	
	mixin("int x = 42;");
	mixin("writeln(x);");

	writeln(BinaryOperation!("+",int)(7,2));
	// Note: D will attempt to infer any unfilled in arguments.
	writeln(BinaryOperation!("+")(7,2)); // plus
	writeln(BinaryOperation!("-")(7,2)); // subtract
	writeln(BinaryOperation!("/")(7,2)); // divide
	writeln(BinaryOperation!("*")(7,2)); // multiply
	writeln(BinaryOperation!("^")(7,2)); // modules
	writeln(BinaryOperation!("|")(7,2)); // or'd bits
	writeln(BinaryOperation!("%")(7,2)); // remainder
}
