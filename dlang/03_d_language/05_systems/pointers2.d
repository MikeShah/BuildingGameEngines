// @file pointers2.d

import std.stdio;

void main(){
    int   x = 7;
    auto px = &x;
		auto y = 8;
		writeln("y is: ",typeid(y));
    
    writeln(x);
    writeln(*px); 
    writeln(typeid(px));
}
