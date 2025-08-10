// @file nogc.d
import std.stdio;

void foo(){
   writeln("hello"); 
}

// As soon as you put '@nogc' on a function,
// any function in the callstack cannot allocate
// (i.e. functions called from main are also nogc
@nogc
void main(){
    foo();
}
