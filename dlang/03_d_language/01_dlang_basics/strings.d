// @file dlang_basics/strings.d
import std.stdio;

void main(){

    // This string is immutable
    string mike = "mike";
    // I can read characters
    writeln(mike[0]);
    // I cannot modify characters
    // mike[0] = 'M'; // ILLEGAL!

    // This string is mutable
    // "hi class" itself is not mutable, again
    // it is a string. But the ".dup" function
    // returns a copy https://dlang.org/library/object/dup.html
    char[] mutable = "hi class".dup;
    mutable[0] = 'H';
    writeln(mutable);
}


