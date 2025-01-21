// @file dlang_basics/typeof.d
import std.stdio;

void main(){

    auto i = 5;

    // Here I want to create a new type
    // based off of the type 'i'
    typeof(i) j = 7;

    writeln(typeid(j));
    
}
