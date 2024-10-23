// 03_wrap
// 
// Modify dub 'targetType' to be a library
// See: https://dub.pm/dub-reference/build_settings/#targettype
// Pybind code
module libpydtest;
import pyd.pyd;

int MyDFunction(int x){
	return x*x;
}
int MyAddFunction(int a,int b){
	return a+b;
}

extern (C) void PydMain(){
	def!(MyAddFunction)();	// Wrap any D functions for Python
	def!(MyDFunction)();	// Wrap any D functions for Python
	module_init();				// After we finish wrapping, then call module_init
}
