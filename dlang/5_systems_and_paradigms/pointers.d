// @file pointers.d

import std.stdio;

void main(){
    int   x = 7;
    int* px = &x;
    
    writeln(x);
    writeln(*px); 
}
