/// @file dlang_basics/auto.d
import std.stdio;

auto sum(int a, int b){
    return a + b;
}

void main(){

    auto i = 5;
    writeln(5);
    /// Retrieve the derived type wit 'typeid'
    writeln(typeid(i));

    writeln(sum(4,5));
    writeln(typeid(sum(4,5)));
}
