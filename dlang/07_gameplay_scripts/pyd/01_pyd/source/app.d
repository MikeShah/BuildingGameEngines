// 01_pyd
// 
// Make sure to edit your
// subConfiguration for your pyd
// e.g. python3.10 = python310
//      python3.6  = python36
// See: https://dub.pm/dub-reference/build_settings/#subconfigurations
import std.stdio;

// Pybind code
import pyd.pyd;
import pyd.embedded;

shared static this(){
	// Initializes the python interpreter.
	// Needed before we make any python calls.
	py_init();
}

void main()
{
	// Use Python to evaluate a simple expression
	int integer = py_eval!int("5 + 7 * 2");
	writeln("integer: ", integer);

	// Execute arbitary python code from a module
	// This is without any context, but otherwise grabbing from 'random'
  PydObject ints = py_eval("[randint(1, 9) for i in range(20)]", "random");
	writeln(ints);
	
	// ---------- Running Python interpreter in D ------ //
	// Think of InterpContext as a new instance of python interpreter
	auto context = new InterpContext();
	context.py_stmts("value =5 ");							// Create a variable in a new context
	context.py_stmts("value = 5 * 5 ");					//
	PydObject value = context.py_eval("value"); // Extract out the value
	writeln(value);

	// ---------- Running Python interpreter in D ------ //
}
