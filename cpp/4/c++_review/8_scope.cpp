// clang++ -std=c++11 8_scope.cpp -o scope 
#include <iostream>

int main(){

    // Curly braces start and end scope of a primitive type or object
    {
        int x = 5;
    } // 'x=5' no longer exists after this line.    

    {
        int x = 7;
    } // This 'x=7' no longer exists.

    return 0;
}
