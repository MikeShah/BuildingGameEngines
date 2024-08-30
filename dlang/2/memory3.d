// @file memory3.d
import std.stdio;

void Safe() @safe{
    string[] strings = new string[5];
    writeln(strings);
   //    UnSafe(); // Cannot call unsafe(i.e. system)
                // code within @safe functions.
                // Can call other @safe or @trusted.
}

void UnSafe() @system // Note: @system is the default
{                     // so you don't have to label
    int* p = new int;
    // Pointer arithemtic generally is
    // not 'safe'

    // TRY changing @system to @safe here, and
    //     this will not compile
    p = p + 1;
}

void main(){
    Safe();
    UnSafe();
}

