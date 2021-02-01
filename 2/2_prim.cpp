// clang++ -std=c++11 2_prim.cpp -o prim
#include <iostream>
// Declare variable ahead of use
// This variable is outside scope of any 
// function, so it is also 'global'
// (i.e. available anywhere)
const float PI = 3.1415;
// ('const' means PI will not change)
// Define a primitive char
char status;

int main(){

    // Use '<<' operator to output multiple values
    std::cout << "PI is: " << PI << '\n';
    // Best practice(read: almost always) 
    // define value of variable before use.
    status = 'A';
    // Note, '\n' in single quotes because it is
    // an escape sequence represented in one char.
    std::cout << "status: " << status << '\n';

    return 0;
}
