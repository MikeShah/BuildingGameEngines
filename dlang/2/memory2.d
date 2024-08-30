// @file memory2.d
import std.stdio;

void main(){

    int myInt;
    int* pointerToInteger = &myInt;

    writeln(&myInt);
    writeln(pointerToInteger);

}



