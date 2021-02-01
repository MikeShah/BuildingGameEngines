// clang++ -std=c++11 15_mem.cpp -o 15_mem
#include <iostream>

// Pass x 'by reference'
void setValue(int &a){
    // Whatever is in the memory at 
    // address of a(the parameter sent in)
    // change that value to 9999
    a = 9999;
}

int main(){
    int x = 42;
    setValue(x);
    std::cout << "x is " << x << '\n';

    return 0;
}
