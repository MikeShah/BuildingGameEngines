// clang++ -std=c++11 1_hello_annotated.cpp -o hello

// Bring in a header file on our include path
// this happens to be in the standard library
// (i.e. default compiler path)
#include <iostream>

// main function -- entry point into program
int main(int argc, char* argv[]){

    // From the standard library namespace
    // Output to standard output stream 
    // a 'string' "hello
    std::cout << "hello" << std::endl;

    // Return from our function
    // 0 -  typically means 'success' from a 
    //      main function.
    return 0;
}

