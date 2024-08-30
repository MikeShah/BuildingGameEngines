// @file compile_time.d
// Note: Just 'compile' this file, do not execute it.
//       The 'pragma' willl then 'print' at compile-time the values
//       when that line is parsed.
//       Again -- the program is not running, only the compiler, evaluating
//       the function call if all values are known at compile-time.
import std.algorithm;
void main(){

	enum values = [7,12,15,17,14];
	enum result = values.sort;
	
	pragma(msg,result);
}
