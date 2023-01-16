// clang++ -std=c++11 4_function.cpp -o function
#include <iostream>

// Forward declare our function
int square(int x);

int main(){

    // 'call' our function and specify 5 as the value
    // of its first argument.
    std::cout << "square(5) = " << square(5) << '\n';

    return 0;
}

// Function definition
int square(int x){
    return x*x;
}


