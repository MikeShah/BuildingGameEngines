// @file dlang_basics/functions.d
import std.stdio;

void func(){
    void localFunc(){
    }
}

void main(){

    // unnamed functions allowed. 
    // Return type is deduced with 'auto'
    auto anonymousFunction = (int a, int b){
        return a + b;
    };
    // One-line functions (lambdas) allowed
    auto lambda = (int a, int b) => a +b;

    writeln(anonymousFunction(4,5));
    writeln(lambda(4,5));
}
