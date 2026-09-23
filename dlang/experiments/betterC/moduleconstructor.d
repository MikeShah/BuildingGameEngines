// There are a few ways to get functions called prior to 
// the main() function.
// In D, these would be known as 'module constructors', but in the betterC mode, 
// these are not available. My underestanding, is that module constructors would
// be handled in the d runtime, which is otherwise stripped away in betterC mode.
// However, most compilers (gcc, clang, etc.) can provide some constructs for
// constructors in some form.
// We could also hijack the _start symbol perhaps, and build a list of functions 
// to be called.
//
// See: https://dlang.org/spec/pragma.html#crtctor for the built-ins
// See: https://gcc.gnu.org/onlinedocs/gcc-16.1.0/gdc/Predefined-Pragmas.html
//
// dmd -betterC moduleconstructor.d -of=prog && ./prog
//
//

import core.stdc.stdio;
import core.stdc.stdlib;
//import std.stdio; // Not allowed in betterC mode because of exceptions.


pragma(crt_constructor) void myInit() {
    // Initialization code here
  core.stdc.stdio.printf("crt_constructor\n");
}

pragma(crt_destructor) void myDestroy() {
    // Initialization code here
  core.stdc.stdio.printf("crt_destructor\n");
}
pragma(crt_destructor) void myDestroy2() {
    // Initialization code here
  core.stdc.stdio.printf("crt_destructor2\n");
}


extern(C) void main(){

  core.stdc.stdio.printf("D Lang main\n");
  //writeln("D Lang main");
  exit(0);
}
