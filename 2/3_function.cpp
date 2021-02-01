// clang++ -std=c++11 3_function.cpp -o function
#include <iostream>

// Declare and Define a function
// before we use it later on
int square(int x){
    return x*x;
}

int main(){

    // 'call' our function and specify 5 as the value
    // of its first argument.
    std::cout << "square(5) = " << square(5) << '\n';

    return 0;
}


