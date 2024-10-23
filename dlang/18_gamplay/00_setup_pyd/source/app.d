// 00_setup_pyd
import std.stdio;
import pyd.pyd, pyd.embedded;

shared static this(){
	// Initializes the python interpreter
	// Needed before we make any python calls
	py_init();
}

void main()
{
	writeln("Write to stdout with D");
	// Evaluate a python statement using the python interpreter
	py_eval!string("print('write to stdout with python')");
}
