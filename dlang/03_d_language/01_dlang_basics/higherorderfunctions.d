// @file dlang_basics/higherorderfunctions.d 
import std.stdio;

int Add(int x, int y){
    return x+y;
}

int Subtract(int x, int y){
    return x-y;
}

// Observe the 'function' keyword allowing functions to
// be passed conveniently as an argument. The signature
// of the argument must match the incoming function
int Perform(int function(int,int) func, int a, int b){
    return func(a,b);
}

void main(){
    // 
    int result1 = Perform(&Subtract,5,2);
    int result2 = Perform(&Add,2,5);
    writeln(result1);
    writeln(result2);
}
