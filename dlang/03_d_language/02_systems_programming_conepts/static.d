// @file static.d
import std.stdio;
void foo(){
    // 
    static i =0; // equivalent to:
                 // static int i=0; OR
                 // static auto i=0;

    i++;
    writeln(i);
}

void main(){
		int mike=0;
    foo();
    foo();
    foo();
}
