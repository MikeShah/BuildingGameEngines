// @file dlang_basics/immutable.d
import std.stdio;

void main(){

    // variables marked 'const'
    // cannot be changed.
    immutable int immutable_int = 5;

    // Try uncommenting the below,
    // and you will get an error
//    immutable_int = 7;

}



